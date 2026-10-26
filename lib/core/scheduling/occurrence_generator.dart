import '../models/routine_item.dart';
import 'occurrence.dart';
import 'schedule.dart';

List<RoutineOccurrence> generateOccurrences({
  required RoutineItem item,
  required RoutineSchedule schedule,
  required DateTime from,
  required DateTime through,
}) {
  if (item.isPaused || item.isArchived || through.isBefore(from))
    return const [];
  final results = <RoutineOccurrence>[];
  for (var day = _dateOnly(from);
      !day.isAfter(_dateOnly(through));
      day = day.add(const Duration(days: 1))) {
    if (!schedule.appliesTo(day)) continue;
    for (var index = 0; index < schedule.timeSlots.length; index++) {
      final time = schedule.timeSlots[index].on(day);
      if (time.isBefore(from) || time.isAfter(through)) continue;
      results.add(RoutineOccurrence(
          id: '${item.id}_${time.millisecondsSinceEpoch}_$index',
          itemId: item.id,
          scheduledAt: time,
          status: OccurrenceStatus.pending));
    }
  }
  return results;
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
