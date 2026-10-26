import 'dart:io';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:currency_picker/currency_picker.dart';

import '../../app/app_providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/notifications/notification_permission_service.dart';
import '../../features/onboarding/legal_document_page.dart';
import '../../shared/widgets/bunny_mascot.dart';
import '../../l10n/ui_text.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesStoreProvider);
    return Scaffold(
      appBar: AppBar(
          title: Text(uiText(context, 'settingsTitle')),
          backgroundColor: Colors.transparent),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 110),
          children: [
            Card(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Row(children: [
                      const BunnyMascot(size: 74),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(preferences.username ?? 'Luna',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 3),
                            const Text('Manage your profile',
                                style: TextStyle(
                                    fontSize: 10, color: AppColors.mutedBrown))
                          ])),
                      const SizedBox(width: 8)
                    ]))),
            const SizedBox(height: 8),
            _card([
              _row(
                  Icons.edit_outlined,
                  uiText(context, 'editUsername'),
                  preferences.username ?? 'Add your name',
                  () => _editUsername(preferences.username ?? '')),
              _row(Icons.language_outlined, uiText(context, 'language'),
                  _languageName(preferences.language), _chooseLanguage),
              _row(
                  Icons.currency_exchange_outlined,
                  uiText(context, 'currency'),
                  preferences.currencyCode,
                  _chooseCurrency),
              _row(Icons.notifications_none, uiText(context, 'notifications'),
                  'Manage reminder settings', _requestNotifications),
              _row(Icons.backup_outlined, uiText(context, 'backup'),
                  'Export or import your data', _backupRestore),
              _row(Icons.delete_outline, uiText(context, 'deleteAll'),
                  'Remove everything from this device', _deleteAllData,
                  danger: true),
            ]),
            const SizedBox(height: 8),
            Card(
                child: Row(children: [
              Expanded(
                  child: TextButton(
                      onPressed: () =>
                          _openLegal('Terms of Use', LegalDocumentPage.terms),
                      child: const Text('Terms of Use',
                          style: TextStyle(fontSize: 10)))),
              Expanded(
                  child: TextButton(
                      onPressed: () => _openLegal(
                          'Privacy Policy', LegalDocumentPage.privacy),
                      child: const Text('Privacy Policy',
                          style: TextStyle(fontSize: 10)))),
              Expanded(
                  child: TextButton(
                      onPressed: _about,
                      child:
                          const Text('About', style: TextStyle(fontSize: 10))))
            ])),
          ]),
    );
  }

  Widget _card(List<Widget> children) => Card(
          child: Column(children: [
        for (var index = 0; index < children.length; index++) ...[
          children[index],
          if (index < children.length - 1)
            const Divider(height: 1, indent: 52, endIndent: 12)
        ]
      ]));

  Widget _row(IconData icon, String title, String subtitle, VoidCallback onTap,
          {bool danger = false}) =>
      ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        leading: Icon(icon,
            size: 18, color: danger ? AppColors.errorRose : AppColors.rosePink),
        title: Text(title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 10, color: AppColors.mutedBrown)),
        trailing: const Icon(Icons.chevron_right,
            size: 18, color: AppColors.mutedBrown),
        onTap: onTap,
      );

  Future<void> _editUsername(String current) async {
    final value = await showDialog<String>(
        context: context,
        builder: (_) => _UsernameDialog(initialValue: current));
    if (!mounted) return;
    if (value != null && value.isNotEmpty) {
      await ref.read(preferencesStoreProvider).setUsername(value);
      setState(() {});
    }
  }

  Future<void> _chooseLanguage() async {
    final selected = await _choiceDialog(
        'Language',
        ['English', '日本語', '中文', '한국어'],
        ref.read(preferencesStoreProvider).language);
    if (selected != null) {
      await ref.read(preferencesStoreProvider).setLanguage(selected);
      setState(() {});
    }
  }

  String _languageName(String code) => switch (code) {
        'ja' => '日本語',
        'zh' => '中文',
        'ko' => '한국어',
        _ => 'English'
      };

  Future<void> _chooseCurrency() async {
    showCurrencyPicker(
        context: context,
        showFlag: true,
        showCurrencyName: true,
        showCurrencyCode: true,
        onSelect: (currency) =>
            ref.read(preferencesStoreProvider).setCurrencyCode(currency.code));
  }

  Future<String?> _choiceDialog(
      String title, List<String> options, String selected) {
    if (title == 'Language') options = ['en', 'ja', 'zh', 'ko'];
    return showDialog<String>(
        context: context,
        builder: (dialogContext) => SimpleDialog(title: Text(title), children: [
              for (final option in options)
                RadioListTile<String>(
                    value: option,
                    groupValue: selected,
                    onChanged: (value) =>
                        Navigator.of(dialogContext).pop(value),
                    title: Text(
                        title == 'Language' ? _languageName(option) : option))
            ]));
  }

  Future<void> _requestNotifications() async {
    final preferences = ref.read(preferencesStoreProvider);
    await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) => StatefulBuilder(
            builder: (context, setModalState) => SafeArea(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SwitchListTile(
                      title: const Text('Routine notifications'),
                      subtitle: const Text('Show scheduled reminders'),
                      value: preferences.notificationsEnabled,
                      onChanged: (value) async {
                        await preferences.setNotificationsEnabled(value);
                        ref
                            .read(notificationPermissionServiceProvider)
                            .configure(
                                notifications: value,
                                alarms: preferences.alarmEnabled);
                        await ref
                            .read(notificationPermissionServiceProvider)
                            .reconcile(ref.read(routineRepositoryProvider));
                        setModalState(() {});
                      }),
                  SwitchListTile(
                      title: const Text('Alarm-style reminders'),
                      subtitle: const Text('Allow exact alarm reminders'),
                      value: preferences.alarmEnabled,
                      onChanged: (value) async {
                        await preferences.setAlarmEnabled(value);
                        ref
                            .read(notificationPermissionServiceProvider)
                            .configure(
                                notifications: preferences.notificationsEnabled,
                                alarms: value);
                        setModalState(() {});
                      }),
                  ListTile(
                      title: const Text('Remind me before'),
                      trailing: DropdownButton<int>(
                          value: preferences.reminderLeadMinutes,
                          items: const [0, 5, 10, 15, 30, 60]
                              .map((value) => DropdownMenuItem(
                                  value: value, child: Text('$value min')))
                              .toList(),
                          onChanged: (value) async {
                            if (value == null) return;
                            await preferences.setReminderLeadMinutes(value);
                            setModalState(() {});
                          })),
                  FilledButton(
                      onPressed: () async {
                        await ref
                            .read(notificationPermissionServiceProvider)
                            .requestAll();
                        if (sheetContext.mounted) {
                          Navigator.of(sheetContext).pop();
                        }
                      },
                      child: const Text('Allow permissions')),
                  const SizedBox(height: 12)
                ]))));
  }

  Future<File> _backupFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(path.join(directory.path, 'routinebunny-backup.json'));
  }

  Future<void> _backupRestore() async {
    final action = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) => SafeArea(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                  leading: const Icon(Icons.file_upload_outlined),
                  title: const Text('Export backup'),
                  subtitle: const Text('Save a JSON copy on this device'),
                  onTap: () => Navigator.of(sheetContext).pop('export')),
              ListTile(
                  leading: const Icon(Icons.file_download_outlined),
                  title: const Text('Import backup'),
                  subtitle: const Text('Restore the saved JSON copy'),
                  onTap: () => Navigator.of(sheetContext).pop('import'))
            ])));
    if (action == 'export') {
      final file = await _backupFile();
      final backup = jsonDecode(
              await ref.read(routineRepositoryProvider).exportBackupJson())
          as Map<String, dynamic>;
      backup['temporaryTasks'] =
          ref.read(temporaryTaskStoreProvider).exportData();
      await file.writeAsString(jsonEncode(backup));
      await SharePlus.instance.share(
          ShareParams(files: [XFile(file.path)], text: 'RoutineBunny backup'));
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Backup saved as ${file.path}')));
    }
    if (action == 'import') {
      final picked = await FilePicker.pickFiles(
          type: FileType.custom, allowedExtensions: ['json']);
      if (picked.isEmpty) return;
      final source = utf8.decode(await picked.single.readAsBytes());
      final confirmed = await _confirm('Import backup?',
          'This replaces the routines and history currently stored on this device.');
      if (confirmed == true) {
        try {
          await ref.read(routineRepositoryProvider).importBackupJson(source);
          final backup = jsonDecode(source) as Map<String, dynamic>;
          await ref
              .read(temporaryTaskStoreProvider)
              .importData((backup['temporaryTasks'] as List?) ?? const []);
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup restored.')));
        } catch (error) {
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Backup was not restored: $error')));
        }
      }
    }
  }

  Future<void> _deleteAllData() async {
    final confirmed = await _confirm('Delete all data?',
        'This permanently removes routines, schedules, history, and your profile from this device. Export a backup first if you may need it.');
    if (confirmed == true) {
      await ref.read(routineRepositoryProvider).clearAllData();
      await ref.read(preferencesStoreProvider).clearAll();
      final backup = await _backupFile();
      if (await backup.exists()) await backup.delete();
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All local data was deleted.')));
      }
    }
  }

  Future<bool?> _confirm(String title, String message) => showDialog<bool>(
      context: context,
      builder: (dialogContext) =>
          AlertDialog(title: Text(title), content: Text(message), actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Continue'))
          ]));
  void _openLegal(String title, List<(String, String)> sections) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LegalDocumentPage(title: title, sections: sections)));
  void _about() => showAboutDialog(
      context: context,
      applicationName: 'RoutineBunny',
      applicationVersion: '0.1.0',
      applicationLegalese: 'A local-first routine planner.');
}

class _UsernameDialog extends StatefulWidget {
  const _UsernameDialog({required this.initialValue});
  final String initialValue;

  @override
  State<_UsernameDialog> createState() => _UsernameDialogState();
}

class _UsernameDialogState extends State<_UsernameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Username')),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(_controller.text.trim()),
              child: const Text('Save'))
        ],
      );
}
