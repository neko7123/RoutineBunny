import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class RoutineItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get customFieldsJson => text().withDefault(const Constant('{}'))();
  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class RoutineSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().references(RoutineItems, #id)();
  TextColumn get kind => text()();
  IntColumn get weekdaysMask => integer().withDefault(const Constant(0))();
  DateTimeColumn get oneTimeDate => dateTime().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RoutineTimeSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get scheduleId => text().references(RoutineSchedules, #id)();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  IntColumn get reminderMinutesBefore =>
      integer().withDefault(const Constant(0))();
}

class RoutineOccurrences extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().references(RoutineItems, #id)();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get status => text()();
  DateTimeColumn get recordedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RoutineScheduleOverrides extends Table {
  TextColumn get itemId => text().references(RoutineItems, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get timeSlotsJson => text().withDefault(const Constant('[]'))();
  BoolColumn get isCancelled => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {itemId, date};
}

@DriftDatabase(tables: [
  RoutineItems,
  RoutineSchedules,
  RoutineTimeSlots,
  RoutineOccurrences,
  RoutineScheduleOverrides
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.createTable(routineScheduleOverrides);
        },
        beforeOpen: (details) async {
          if (details.wasCreated)
            await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<List<RoutineItem>> activeItems() =>
      (select(routineItems)..where((item) => item.isArchived.equals(false)))
          .get();
}

Future<AppDatabase> openAppDatabase() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(p.join(directory.path, 'routinebunny.sqlite'));
  return AppDatabase(NativeDatabase.createInBackground(file));
}
