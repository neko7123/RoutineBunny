import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../storage/routine_repository.dart';
import '../scheduling/occurrence.dart';

class NotificationPermissionService {
  NotificationPermissionService(this.plugin);

  final FlutterLocalNotificationsPlugin plugin;
  bool notificationsEnabled = true;
  bool alarmEnabled = false;

  void configure({required bool notifications, required bool alarms}) {
    notificationsEnabled = notifications;
    alarmEnabled = alarms;
  }

  Future<void> initialize() async {
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(
          tz.getLocation(await FlutterTimezone.getLocalTimezone()));
    } catch (_) {
      // UTC fallback is safer than blocking app startup.
    }
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await plugin.initialize(settings);
  }

  Future<void> reconcile(RoutineRepository repository) async {
    if (!notificationsEnabled) {
      try {
        await plugin.cancelAll();
      } catch (_) {}
      return;
    }
    try {
      await plugin.cancelAll();
    } catch (_) {
      return;
    }
    final now = DateTime.now();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
          'routine_reminders', 'Routine reminders',
          channelDescription: 'Scheduled RoutineBunny reminders',
          importance: Importance.high,
          priority: Priority.high),
    );
    for (var offset = 0; offset < 30; offset++) {
      final date = DateUtils.dateOnly(now).add(Duration(days: offset));
      final occurrences = await repository.occurrencesFor(date);
      for (final occurrence in occurrences.where((value) =>
          value.status == OccurrenceStatus.pending &&
          value.scheduledAt.isAfter(now))) {
        final item = repository.items
            .where((value) => value.id == occurrence.itemId)
            .firstOrNull;
        if (item == null) continue;
        try {
          await plugin.zonedSchedule(
              occurrence.id.hashCode.abs(),
              item.name,
              'It is time for your routine.',
              tz.TZDateTime.from(occurrence.scheduledAt, tz.local),
              details,
              androidScheduleMode: alarmEnabled
                  ? AndroidScheduleMode.exactAllowWhileIdle
                  : AndroidScheduleMode.inexactAllowWhileIdle,
              payload: item.id);
        } catch (_) {
          // Permissions or device policy can reject an individual alarm.
        }
      }
    }
  }

  Future<void> requestAll() async {
    final android = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }
}

final notificationPermissionServiceProvider =
    Provider<NotificationPermissionService>((ref) {
  throw StateError(
      'NotificationPermissionService must be initialized before use.');
});
