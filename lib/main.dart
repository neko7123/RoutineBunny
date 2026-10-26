import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/app_providers.dart';
import 'core/storage/preferences_store.dart';
import 'core/storage/routine_repository.dart';
import 'core/database/app_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/notifications/notification_permission_service.dart';
import 'core/storage/temporary_task_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final store = PreferencesStore(sharedPreferences);
  final database = await openAppDatabase();
  final routines = await RoutineRepository.create(database);
  final notificationService =
      NotificationPermissionService(FlutterLocalNotificationsPlugin());
  notificationService.configure(
      notifications: store.notificationsEnabled, alarms: store.alarmEnabled);
  await notificationService.initialize();
  await notificationService.reconcile(routines);
  final temporaryTasks = TemporaryTaskStore(sharedPreferences);
  runApp(
    ProviderScope(
      overrides: [
        preferencesStoreProvider.overrideWith((_) => store),
        routineRepositoryProvider.overrideWith((_) => routines),
        appDatabaseProvider.overrideWithValue(database),
        notificationPermissionServiceProvider
            .overrideWithValue(notificationService),
        temporaryTaskStoreProvider.overrideWith((_) => temporaryTasks),
      ],
      child: const RoutineBunnyApp(),
    ),
  );
}
