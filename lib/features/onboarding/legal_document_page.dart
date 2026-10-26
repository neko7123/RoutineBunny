import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class LegalDocumentPage extends StatelessWidget {
  const LegalDocumentPage(
      {super.key, required this.title, required this.sections});

  final String title;
  final List<(String, String)> sections;

  static const terms = [
    (
      'Using RoutineBunny',
      'RoutineBunny is a personal planning tool. It helps you record routines and reminders, but it does not replace professional medical, legal, or safety advice.'
    ),
    (
      'Your responsibility',
      'You choose what to record and when to act. Check medication instructions with a qualified professional. RoutineBunny never changes a dose, recommends a missed-dose adjustment, or confirms that an activity happened unless you record it.'
    ),
    (
      'Local data',
      'Core routine data is stored on this device. You are responsible for keeping your device secure and for protecting any exported backup files.'
    ),
    (
      'Availability',
      'Notifications and alarms depend on Android permissions, battery settings, device settings, and operating-system behavior. RoutineBunny cannot guarantee that every reminder will appear or sound.'
    ),
    (
      'Changes',
      'We may update these terms when the product or its responsibilities materially change. The app records the accepted terms version locally.'
    ),
  ];

  static const privacy = [
    (
      'What we store',
      'RoutineBunny stores your username, routines, schedules, completion history, optional photos, settings, and local acceptance records on your device.'
    ),
    (
      'What we do not require',
      'RoutineBunny does not require an account, email address, cloud database, mandatory internet connection, or advertising profile for ordinary use.'
    ),
    (
      'Permissions',
      'Notifications and exact-alarm permissions are requested only to provide reminders. Android may restrict or revoke those capabilities independently.'
    ),
    (
      'Backups',
      'When backup and restore are implemented, exported files will be under your control. Treat them as sensitive because they may contain personal routines and photos.'
    ),
    (
      'Deletion',
      'Delete All Data will be designed to remove app-managed local data after confirmation. External exports, screenshots, and operating-system copies may remain.'
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title), backgroundColor: Colors.transparent),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            const Icon(Icons.favorite_border,
                color: AppColors.rosePink, size: 42),
            const SizedBox(height: 14),
            Text('$title · RoutineBunny',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text(
                'Please read this information carefully. It explains how RoutineBunny is intended to work and how your data is treated.',
                style: TextStyle(color: AppColors.mutedBrown)),
            const SizedBox(height: 20),
            ...sections.map((section) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(section.$1,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.cocoaBrown)),
                      const SizedBox(height: 6),
                      Text(section.$2, style: const TextStyle(height: 1.45))
                    ]))),
            const Text('Version 2026-01',
                style: TextStyle(fontSize: 12, color: AppColors.mutedBrown)),
          ],
        ),
      );
}
