import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/storage/preferences_store.dart';
import '../core/storage/routine_repository.dart';
import '../core/database/app_database.dart';
import '../core/storage/temporary_task_store.dart';
import '../core/scheduling/occurrence.dart' as domain;

final preferencesStoreProvider =
    ChangeNotifierProvider<PreferencesStore>((ref) {
  throw StateError('PreferencesStore must be initialized before use.');
});

final routineRepositoryProvider =
    ChangeNotifierProvider<RoutineRepository>((ref) {
  throw StateError('RoutineRepository must be initialized before use.');
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('AppDatabase must be initialized before use.');
});

final temporaryTaskStoreProvider =
    ChangeNotifierProvider<TemporaryTaskStore>((ref) {
  throw StateError('TemporaryTaskStore must be initialized before use.');
});

final occurrencesForDateProvider =
    FutureProvider.family<List<domain.RoutineOccurrence>, DateTime>(
        (ref, date) {
  return ref.watch(routineRepositoryProvider).occurrencesFor(date);
});
