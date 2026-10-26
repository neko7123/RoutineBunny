import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../database/app_database.dart' as db;
import '../models/routine_item.dart' as domain;
import '../scheduling/occurrence.dart';
import '../scheduling/occurrence_generator.dart';
import '../scheduling/schedule.dart';

class RoutineRepository extends ChangeNotifier {
  RoutineRepository._(this._database);

  final db.AppDatabase _database;
  List<domain.RoutineItem> _items = [];
  final Map<String, RoutineSchedule> _schedules = {};
  final Map<String, Map<DateTime, ScheduleOverride>> _overrides = {};
  bool _loaded = false;

  static Future<RoutineRepository> create(db.AppDatabase database) async {
    final repository = RoutineRepository._(database);
    await repository._load();
    return repository;
  }

  List<domain.RoutineItem> get items =>
      List.unmodifiable(_items.where((item) => !item.isArchived));
  RoutineSchedule? scheduleFor(String itemId) => _schedules[itemId];

  Future<void> _load() async {
    final rows = await _database.select(_database.routineItems).get();
    _items = rows.map(_toDomainItem).toList();
    final schedules = await _database.select(_database.routineSchedules).get();
    for (final schedule in schedules) {
      final slots = await (_database.select(_database.routineTimeSlots)
            ..where((slot) => slot.scheduleId.equals(schedule.id)))
          .get();
      _schedules[schedule.itemId] = _toDomainSchedule(schedule, slots);
    }
    final overrides =
        await _database.select(_database.routineScheduleOverrides).get();
    for (final override in overrides) {
      _overrides.putIfAbsent(
              override.itemId, () => {})[_dateOnly(override.date)] =
          ScheduleOverride(
              timeSlots: _decodeTimeSlots(override.timeSlotsJson),
              isCancelled: override.isCancelled);
    }
    _loaded = true;
  }

  Future<void> save(domain.RoutineItem item) async {
    _ensureLoaded();
    final now = DateTime.now();
    final existing = await (_database.select(_database.routineItems)
          ..where((row) => row.id.equals(item.id)))
        .getSingleOrNull();
    await _database.into(_database.routineItems).insertOnConflictUpdate(
          db.RoutineItemsCompanion.insert(
            id: item.id,
            name: item.name,
            category: item.category.name,
            description: Value(item.description),
            photoPath: Value(item.photoPath),
            customFieldsJson: Value(jsonEncode(item.customFields)),
            isPaused: Value(item.isPaused),
            isArchived: Value(item.isArchived),
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
          ),
        );
    final index = _items.indexWhere((value) => value.id == item.id);
    _items = [..._items];
    if (index == -1) {
      _items.add(item);
    } else {
      _items[index] = item;
    }
    notifyListeners();
  }

  Future<void> updateItem(domain.RoutineItem item) => save(item);

  Future<void> setPaused(String id, bool paused) async {
    final current = _items.firstWhere((item) => item.id == id);
    await updateItem(current.copyWith(isPaused: paused));
  }

  Future<void> saveSchedule(String itemId, RoutineSchedule schedule) async {
    _ensureLoaded();
    final scheduleId = '${itemId}_schedule';
    await _database.transaction(() async {
      await (_database.delete(_database.routineTimeSlots)
            ..where((slot) => slot.scheduleId.equals(scheduleId)))
          .go();
      await _database.into(_database.routineSchedules).insertOnConflictUpdate(
            db.RoutineSchedulesCompanion.insert(
              id: scheduleId,
              itemId: itemId,
              kind: schedule.kind == ScheduleKind.interval
                  ? 'interval_${schedule.intervalDays}'
                  : schedule.kind.name,
              weekdaysMask: Value(_weekdayMask(schedule.weekdays)),
              oneTimeDate: Value(schedule.oneTimeDate),
              startDate: Value(schedule.startDate),
              endDate: Value(schedule.endDate),
            ),
          );
      for (final slot in schedule.timeSlots) {
        await _database.into(_database.routineTimeSlots).insert(
            db.RoutineTimeSlotsCompanion.insert(
                scheduleId: scheduleId,
                hour: slot.hour,
                minute: slot.minute,
                reminderMinutesBefore: Value(slot.reminderMinutesBefore)));
      }
    });
    _schedules[itemId] = schedule;
    notifyListeners();
  }

  Future<void> saveOverride(
      String itemId, DateTime date, ScheduleOverride override) async {
    _ensureLoaded();
    final day = _dateOnly(date);
    await _database
        .into(_database.routineScheduleOverrides)
        .insertOnConflictUpdate(
          db.RoutineScheduleOverridesCompanion.insert(
              itemId: itemId,
              date: day,
              timeSlotsJson: Value(jsonEncode(
                  override.timeSlots.map((slot) => slot.toJson()).toList())),
              isCancelled: Value(override.isCancelled)),
        );
    _overrides.putIfAbsent(itemId, () => {})[day] = override;
    notifyListeners();
  }

  Future<List<RoutineOccurrence>> occurrencesFor(DateTime date) async {
    _ensureLoaded();
    final from = _dateOnly(date);
    final through = from
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));
    final generated = [
      for (final item in items)
        if (_schedules[item.id] case final schedule?)
          ..._occurrencesForItem(item, schedule, from, through),
    ];
    if (generated.isEmpty) return const [];
    final stored = await (_database.select(_database.routineOccurrences)
          ..where(
              (row) => row.id.isIn(generated.map((item) => item.id).toList())))
        .get();
    final storedById = {for (final row in stored) row.id: row};
    return generated.map((item) {
      final saved = storedById[item.id];
      return RoutineOccurrence(
          id: item.id,
          itemId: item.itemId,
          scheduledAt: saved?.scheduledAt ?? item.scheduledAt,
          status: saved == null
              ? (item.scheduledAt.isBefore(DateTime.now())
                  ? OccurrenceStatus.missed
                  : OccurrenceStatus.pending)
              : _statusFromString(saved.status));
    }).toList();
  }

  Future<void> setCompleted(
      RoutineOccurrence occurrence, bool completed) async {
    await setStatus(occurrence,
        completed ? OccurrenceStatus.completed : OccurrenceStatus.pending);
  }

  Future<void> setStatus(RoutineOccurrence occurrence, OccurrenceStatus status,
      {DateTime? scheduledAt}) async {
    _ensureLoaded();
    await _database.into(_database.routineOccurrences).insertOnConflictUpdate(
          db.RoutineOccurrencesCompanion.insert(
              id: occurrence.id,
              itemId: occurrence.itemId,
              scheduledAt: scheduledAt ?? occurrence.scheduledAt,
              status: status.name,
              recordedAt: Value(DateTime.now())),
        );
    notifyListeners();
  }

  Future<void> archive(String id) async {
    _ensureLoaded();
    await (_database.update(_database.routineItems)
          ..where((row) => row.id.equals(id)))
        .write(db.RoutineItemsCompanion(
            isArchived: const Value(true), updatedAt: Value(DateTime.now())));
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) _items[index] = _items[index].copyWith(isArchived: true);
    notifyListeners();
  }

  Future<String> exportBackupJson() async {
    _ensureLoaded();
    final occurrences =
        await _database.select(_database.routineOccurrences).get();
    return jsonEncode({
      'version': 1,
      'items': _items.map((item) => item.toJson()).toList(),
      'schedules': [
        for (final entry in _schedules.entries)
          {'itemId': entry.key, ...entry.value.toJson()}
      ],
      'overrides': [
        for (final item in _overrides.entries)
          for (final date in item.value.entries)
            {
              'itemId': item.key,
              'date': date.key.toIso8601String(),
              'timeSlots':
                  date.value.timeSlots.map((slot) => slot.toJson()).toList(),
              'isCancelled': date.value.isCancelled
            }
      ],
      'occurrences': occurrences
          .map((row) => {
                'id': row.id,
                'itemId': row.itemId,
                'scheduledAt': row.scheduledAt.toIso8601String(),
                'status': row.status,
                'recordedAt': row.recordedAt?.toIso8601String()
              })
          .toList(),
    });
  }

  Future<void> importBackupJson(String source) async {
    _ensureLoaded();
    final backup = jsonDecode(source) as Map<String, dynamic>;
    final items = (backup['items'] as List? ?? const [])
        .map((value) => domain.RoutineItem.fromJson(
            Map<String, Object?>.from(value as Map)))
        .toList();
    final itemIds = items.map((item) => item.id).toSet();
    for (final value in (backup['schedules'] as List? ?? const [])) {
      final schedule = Map<String, dynamic>.from(value as Map);
      if (!itemIds.contains(schedule['itemId']))
        throw const FormatException('Backup references an unknown item.');
      final copy = Map<String, Object?>.from(schedule)..remove('itemId');
      RoutineSchedule.fromJson(copy);
    }
    for (final value in (backup['overrides'] as List? ?? const [])) {
      final row = Map<String, dynamic>.from(value as Map);
      if (!itemIds.contains(row['itemId']))
        throw const FormatException(
            'Backup override references an unknown item.');
      DateTime.parse(row['date'] as String);
      ScheduleOverride(
          timeSlots: (row['timeSlots'] as List? ?? const [])
              .map((slot) =>
                  TimeSlot.fromJson(Map<String, Object?>.from(slot as Map)))
              .toList(),
          isCancelled: row['isCancelled'] as bool? ?? false);
    }
    for (final value in (backup['occurrences'] as List? ?? const [])) {
      final row = Map<String, dynamic>.from(value as Map);
      if (!itemIds.contains(row['itemId']))
        throw const FormatException(
            'Backup history references an unknown item.');
      DateTime.parse(row['scheduledAt'] as String);
    }
    await clearAllData();
    for (final item in items) {
      await save(item);
    }
    for (final value in (backup['schedules'] as List? ?? const [])) {
      final schedule = Map<String, dynamic>.from(value as Map);
      final itemId = schedule.remove('itemId') as String;
      await saveSchedule(itemId,
          RoutineSchedule.fromJson(Map<String, Object?>.from(schedule)));
    }
    for (final value in (backup['overrides'] as List? ?? const [])) {
      final row = Map<String, dynamic>.from(value as Map);
      await saveOverride(
        row['itemId'] as String,
        DateTime.parse(row['date'] as String),
        ScheduleOverride(
          timeSlots: (row['timeSlots'] as List? ?? const [])
              .map((slot) =>
                  TimeSlot.fromJson(Map<String, Object?>.from(slot as Map)))
              .toList(),
          isCancelled: row['isCancelled'] as bool? ?? false,
        ),
      );
    }
    for (final value in (backup['occurrences'] as List? ?? const [])) {
      final row = Map<String, dynamic>.from(value as Map);
      await _database.into(_database.routineOccurrences).insertOnConflictUpdate(
          db.RoutineOccurrencesCompanion.insert(
              id: row['id'] as String,
              itemId: row['itemId'] as String,
              scheduledAt: DateTime.parse(row['scheduledAt'] as String),
              status: row['status'] as String,
              recordedAt: Value(row['recordedAt'] == null
                  ? null
                  : DateTime.parse(row['recordedAt'] as String))));
    }
    notifyListeners();
  }

  Future<void> clearAllData() async {
    _ensureLoaded();
    await _database.transaction(() async {
      await _database.delete(_database.routineScheduleOverrides).go();
      await _database.delete(_database.routineOccurrences).go();
      await _database.delete(_database.routineTimeSlots).go();
      await _database.delete(_database.routineSchedules).go();
      await _database.delete(_database.routineItems).go();
    });
    _items = [];
    _schedules.clear();
    _overrides.clear();
    notifyListeners();
  }

  List<RoutineOccurrence> _occurrencesForItem(domain.RoutineItem item,
      RoutineSchedule schedule, DateTime from, DateTime through) {
    final override = _overrides[item.id]?[_dateOnly(from)];
    if (override?.isCancelled == true) return const [];
    return generateOccurrences(
        item: item,
        schedule: override == null
            ? schedule
            : schedule.copyWith(timeSlots: override.timeSlots),
        from: from,
        through: through);
  }

  domain.RoutineItem _toDomainItem(db.RoutineItem row) => domain.RoutineItem(
      id: row.id,
      name: row.name,
      category: domain.RoutineCategory.values.firstWhere(
          (value) => value.name == row.category,
          orElse: () => domain.RoutineCategory.custom),
      description: row.description,
      photoPath: row.photoPath,
      customFields: Map<String, String>.from(
          (jsonDecode(row.customFieldsJson) as Map)
              .map((key, value) => MapEntry('$key', '$value'))),
      isPaused: row.isPaused,
      isArchived: row.isArchived);

  RoutineSchedule _toDomainSchedule(
      db.RoutineSchedule row, List<db.RoutineTimeSlot> slots) {
    final interval = row.kind.startsWith('interval_')
        ? int.tryParse(row.kind.substring('interval_'.length))
        : null;
    return RoutineSchedule(
        kind: interval == null
            ? ScheduleKind.values.firstWhere((value) => value.name == row.kind,
                orElse: () => ScheduleKind.daily)
            : ScheduleKind.interval,
        intervalDays: interval ?? 1,
        weekdays: _weekdaysFromMask(row.weekdaysMask),
        timeSlots: slots
            .map((slot) => TimeSlot(
                hour: slot.hour,
                minute: slot.minute,
                reminderMinutesBefore: slot.reminderMinutesBefore))
            .toList(),
        oneTimeDate: row.oneTimeDate,
        startDate: row.startDate,
        endDate: row.endDate);
  }

  List<TimeSlot> _decodeTimeSlots(String value) {
    try {
      return (jsonDecode(value) as List<dynamic>)
          .map((slot) =>
              TimeSlot.fromJson(Map<String, Object?>.from(slot as Map)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static int _weekdayMask(Set<int> weekdays) =>
      weekdays.fold(0, (mask, day) => mask | (1 << (day - 1)));
  static Set<int> _weekdaysFromMask(int mask) => {
        for (var day = 1; day <= 7; day++)
          if ((mask & (1 << (day - 1))) != 0) day
      };
  static OccurrenceStatus _statusFromString(String value) =>
      OccurrenceStatus.values.firstWhere((status) => status.name == value,
          orElse: () => OccurrenceStatus.pending);
  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
  void _ensureLoaded() {
    if (!_loaded)
      throw StateError('RoutineRepository has not finished loading.');
  }
}
