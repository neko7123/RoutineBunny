import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/models/routine_item.dart';
import '../../app/app_providers.dart';
import '../../shared/widgets/category_illustration.dart';
import '../../shared/widgets/nav_icon.dart';
import '../calendar/calendar_page.dart';
import '../home/home_page.dart';
import '../items/add_page.dart';
import '../items/shelf_page.dart';
import '../settings/settings_page.dart';
import '../../l10n/app_localizations.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const CalendarPage(),
      const SizedBox(),
      const ShelfPage(),
      const SettingsPage()
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: AppColors.softWhite,
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 7),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _destination(0, NavIconType.home,
                AppLocalizations.of(context)?.home ?? 'Home'),
            _destination(1, NavIconType.calendar,
                AppLocalizations.of(context)?.calendar ?? 'Calendar'),
            _addDestination(),
            _destination(3, NavIconType.items,
                AppLocalizations.of(context)?.myShelf ?? 'Items'),
            _destination(4, NavIconType.settings,
                AppLocalizations.of(context)?.settings ?? 'Settings'),
          ]),
        ),
      ),
    );
  }

  Widget _destination(int index, NavIconType type, String label) {
    final selected = _index == index;
    return InkWell(
        onTap: () => setState(() => _index = index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              NavIcon(type: type, selected: selected, size: 30),
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color:
                          selected ? AppColors.rosePink : AppColors.mutedBrown,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500))
            ])));
  }

  Widget _addDestination() => InkWell(
      onTap: _showAddMenu,
      borderRadius: BorderRadius.circular(30),
      child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            NavIcon(type: NavIconType.add, selected: true, size: 34),
            SizedBox(height: 2),
            Text('Add',
                style: TextStyle(
                    fontSize: 10,
                    color: AppColors.rosePink,
                    fontWeight: FontWeight.w700))
          ])));

  Future<void> _showAddMenu() async {
    final category = await showModalBottomSheet<RoutineCategory>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              const Expanded(
                  child: Center(
                      child: Text('Add New Item',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)))),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20))
            ]),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Choose what you want to add',
                    style:
                        TextStyle(fontSize: 10, color: AppColors.mutedBrown))),
            const SizedBox(height: 10),
            _addChoice(context, RoutineCategory.skincare, 'Product',
                'Skincare, supplements etc.'),
            _addChoice(context, RoutineCategory.wellness, 'Activity',
                'Exercise, self-care etc.'),
            _addChoice(context, RoutineCategory.medication, 'Medication',
                'Tablets, prescribed medicines etc.'),
            _addChoice(context, RoutineCategory.custom, 'Quick Add to a Day',
                'One-time or unscheduled'),
          ]),
        ),
      ),
    );
    if (!mounted || category == null) return;
    if (category == RoutineCategory.custom) {
      await _addOneDayTask();
      if (mounted) setState(() => _index = 0);
      return;
    }
    setState(() => _index = 2);
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AddPage(
            initialCategory: category,
            onSaved: () => Navigator.of(context).pop())));
    if (mounted)
      setState(() => _index = category == RoutineCategory.custom ? 0 : 3);
  }

  Future<void> _addOneDayTask() async {
    final nameController = TextEditingController();
    var time = TimeOfDay.now();
    final result = await showDialog<TimeOfDay>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
                    title: const Text('Quick Add to a Day'),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      TextField(
                          controller: nameController,
                          autofocus: true,
                          decoration:
                              const InputDecoration(labelText: 'Task name')),
                      ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Time'),
                          subtitle: Text(time.format(context)),
                          onTap: () async {
                            final picked = await showTimePicker(
                                context: context, initialTime: time);
                            if (picked != null)
                              setDialogState(() => time = picked);
                          })
                    ]),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () => Navigator.pop(dialogContext, time),
                          child: const Text('Add'))
                    ])));
    final name = nameController.text.trim();
    nameController.dispose();
    if (!mounted || result == null || name.isEmpty) return;
    await ref.read(temporaryTaskStoreProvider).add(
        date: DateUtils.dateOnly(DateTime.now()), name: name, time: result);
  }

  Widget _addChoice(BuildContext context, RoutineCategory category,
          String title, String subtitle) =>
      Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.borderPink)),
          child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              leading: CategoryIllustration(category: category, size: 44),
              title: Text(title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w800)),
              subtitle: Text(subtitle,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.mutedBrown)),
              onTap: () => Navigator.pop(context, category)));
}
