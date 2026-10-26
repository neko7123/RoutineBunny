enum OccurrenceStatus {
  pending,
  completed,
  skipped,
  missed,
  snoozed,
  rescheduled,
  cancelled
}

class RoutineOccurrence {
  const RoutineOccurrence({
    required this.id,
    required this.itemId,
    required this.scheduledAt,
    required this.status,
  });

  final String id;
  final String itemId;
  final DateTime scheduledAt;
  final OccurrenceStatus status;
}

class ProgressSummary {
  const ProgressSummary({required this.completed, required this.denominator});

  final int completed;
  final int denominator;

  bool get hasActivities => denominator > 0;
  double get fraction => denominator == 0 ? 0 : completed / denominator;
}

ProgressSummary calculateProgress(Iterable<RoutineOccurrence> occurrences) {
  var completed = 0;
  var denominator = 0;
  for (final occurrence in occurrences) {
    if (occurrence.status == OccurrenceStatus.cancelled ||
        occurrence.status == OccurrenceStatus.skipped ||
        occurrence.status == OccurrenceStatus.rescheduled) continue;
    denominator++;
    if (occurrence.status == OccurrenceStatus.completed) completed++;
  }
  return ProgressSummary(completed: completed, denominator: denominator);
}
