enum ScheduleKind { daily, selectedWeekdays, interval, oneTime, noSchedule }

class RoutineSchedule {
  const RoutineSchedule({
    required this.kind,
    this.weekdays = const {},
    this.timeSlots = const [],
    this.oneTimeDate,
    this.startDate,
    this.endDate,
    this.intervalDays = 1,
  });

  final ScheduleKind kind;
  final Set<int> weekdays;
  final List<TimeSlot> timeSlots;
  final DateTime? oneTimeDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final int intervalDays;

  bool appliesTo(DateTime date) {
    if (kind == ScheduleKind.noSchedule) return false;
    final day = DateTime(date.year, date.month, date.day);
    if (startDate != null && day.isBefore(_dateOnly(startDate!))) return false;
    if (endDate != null && day.isAfter(_dateOnly(endDate!))) return false;
    if (kind == ScheduleKind.oneTime)
      return oneTimeDate != null && _dateOnly(oneTimeDate!) == day;
    if (kind == ScheduleKind.selectedWeekdays)
      return weekdays.contains(date.weekday);
    if (kind == ScheduleKind.interval) {
      final anchor = _dateOnly(startDate ?? oneTimeDate ?? DateTime.now());
      return !day.isBefore(anchor) &&
          day.difference(anchor).inDays % intervalDays == 0;
    }
    return true;
  }

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'weekdays': weekdays.toList(),
        'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
        'oneTimeDate': oneTimeDate?.toIso8601String(),
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'intervalDays': intervalDays,
      };

  factory RoutineSchedule.fromJson(Map<String, Object?> json) {
    final kindName = json['kind'] as String? ?? ScheduleKind.daily.name;
    return RoutineSchedule(
      kind: ScheduleKind.values.firstWhere((value) => value.name == kindName,
          orElse: () => ScheduleKind.daily),
      weekdays:
          ((json['weekdays'] as List?) ?? const []).whereType<int>().toSet(),
      timeSlots: ((json['timeSlots'] as List?) ?? const [])
          .map((value) =>
              TimeSlot.fromJson(Map<String, Object?>.from(value as Map)))
          .toList(),
      oneTimeDate: _parseDate(json['oneTimeDate']),
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      intervalDays: json['intervalDays'] as int? ?? 1,
    );
  }

  static DateTime? _parseDate(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  RoutineSchedule copyWith(
          {ScheduleKind? kind,
          Set<int>? weekdays,
          List<TimeSlot>? timeSlots,
          DateTime? oneTimeDate,
          DateTime? startDate,
          DateTime? endDate,
          int? intervalDays}) =>
      RoutineSchedule(
          kind: kind ?? this.kind,
          weekdays: weekdays ?? this.weekdays,
          timeSlots: timeSlots ?? this.timeSlots,
          oneTimeDate: oneTimeDate ?? this.oneTimeDate,
          startDate: startDate ?? this.startDate,
          endDate: endDate ?? this.endDate,
          intervalDays: intervalDays ?? this.intervalDays);
}

class TimeSlot {
  const TimeSlot(
      {required this.hour,
      required this.minute,
      this.reminderMinutesBefore = 0})
      : assert(hour >= 0 && hour <= 23),
        assert(minute >= 0 && minute <= 59),
        assert(reminderMinutesBefore >= 0);

  final int hour;
  final int minute;
  final int reminderMinutesBefore;

  DateTime on(DateTime date) =>
      DateTime(date.year, date.month, date.day, hour, minute);

  Map<String, Object?> toJson() => {
        'hour': hour,
        'minute': minute,
        'reminderMinutesBefore': reminderMinutesBefore
      };

  factory TimeSlot.fromJson(Map<String, Object?> json) => TimeSlot(
      hour: json['hour'] as int? ?? 8,
      minute: json['minute'] as int? ?? 0,
      reminderMinutesBefore: json['reminderMinutesBefore'] as int? ?? 0);
}

class ScheduleOverride {
  const ScheduleOverride({this.timeSlots = const [], this.isCancelled = false});

  final List<TimeSlot> timeSlots;
  final bool isCancelled;
}
