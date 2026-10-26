import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:routinebunny/core/database/app_database.dart' as db;
import 'package:routinebunny/core/models/routine_item.dart';
import 'package:routinebunny/core/scheduling/schedule.dart';
import 'package:routinebunny/core/storage/routine_repository.dart';

void main() {
  test('backup restores an item and its schedule', () async {
    final database = db.AppDatabase(NativeDatabase.memory());
    final repository = await RoutineRepository.create(database);
    const item = RoutineItem(
        id: 'serum', name: 'Serum', category: RoutineCategory.skincare);
    await repository.save(item);
    await repository.saveSchedule(
        item.id,
        const RoutineSchedule(
            kind: ScheduleKind.daily,
            timeSlots: [TimeSlot(hour: 8, minute: 0)]));
    final backup = await repository.exportBackupJson();
    await repository.clearAllData();
    await repository.importBackupJson(backup);
    expect(repository.items.single.name, 'Serum');
    expect(repository.scheduleFor('serum')?.timeSlots.single.hour, 8);
    await database.close();
  });
}
