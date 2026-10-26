import 'package:flutter_test/flutter_test.dart';

import 'package:routinebunny/core/models/routine_item.dart';
import 'package:routinebunny/core/scheduling/occurrence.dart';
import 'package:routinebunny/core/scheduling/occurrence_generator.dart';
import 'package:routinebunny/core/scheduling/schedule.dart';

void main() {
  const item = RoutineItem(
      id: 'cleanser', name: 'Cleanser', category: RoutineCategory.skincare);

  test('generates one occurrence per time slot on selected weekdays', () {
    const schedule = RoutineSchedule(
      kind: ScheduleKind.selectedWeekdays,
      weekdays: {DateTime.monday, DateTime.wednesday},
      timeSlots: [TimeSlot(hour: 8, minute: 0), TimeSlot(hour: 20, minute: 30)],
    );
    final occurrences = generateOccurrences(
        item: item,
        schedule: schedule,
        from: DateTime(2026, 10, 26),
        through: DateTime(2026, 11, 1));
    expect(occurrences, hasLength(4));
    expect(occurrences.map((value) => value.scheduledAt.hour), [8, 20, 8, 20]);
  });

  test(
      'skipped and cancelled occurrences are excluded from progress denominator',
      () {
    final summary = calculateProgress([
      RoutineOccurrence(
          id: '1',
          itemId: item.id,
          scheduledAt: DateTime(2026),
          status: OccurrenceStatus.completed),
      RoutineOccurrence(
          id: '2',
          itemId: item.id,
          scheduledAt: DateTime(2026),
          status: OccurrenceStatus.pending),
      RoutineOccurrence(
          id: '3',
          itemId: item.id,
          scheduledAt: DateTime(2026),
          status: OccurrenceStatus.skipped),
      RoutineOccurrence(
          id: '4',
          itemId: item.id,
          scheduledAt: DateTime(2026),
          status: OccurrenceStatus.cancelled),
    ]);
    expect(summary.completed, 1);
    expect(summary.denominator, 2);
    expect(summary.fraction, 0.5);
  });

  test('no schedule never generates occurrences', () {
    const schedule = RoutineSchedule(
        kind: ScheduleKind.noSchedule,
        timeSlots: [TimeSlot(hour: 8, minute: 0)]);
    expect(
        generateOccurrences(
            item: item,
            schedule: schedule,
            from: DateTime(2026, 10, 26),
            through: DateTime(2026, 10, 27)),
        isEmpty);
  });
}
