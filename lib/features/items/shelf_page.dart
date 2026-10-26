import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/routine_item.dart';
import '../../core/scheduling/schedule.dart';
import '../../shared/widgets/category_illustration.dart';
import 'add_page.dart';
import 'item_detail_page.dart';

class ShelfPage extends ConsumerStatefulWidget {
  const ShelfPage({super.key});

  @override
  ConsumerState<ShelfPage> createState() => _ShelfPageState();
}

class _ShelfPageState extends ConsumerState<ShelfPage> {
  String _category = 'All';
  String _query = '';
  bool _searching = false;
  String _sort = 'Recently added';

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(routineRepositoryProvider);
    final items = _visibleItems(repository.items, repository);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 18,
        title: _searching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: 'Search your shelf', border: InputBorder.none),
                onChanged: (value) => setState(() => _query = value),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('My Little Shelf',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  Text('${repository.items.length} items',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.mutedBrown)),
                ],
              ),
        actions: [
          IconButton(
            tooltip: _searching ? 'Close search' : 'Search shelf',
            icon: Icon(_searching ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () => setState(() {
              _searching = !_searching;
              if (!_searching) _query = '';
            }),
          ),
          IconButton(
            tooltip: 'Sort and filter items',
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showShelfOptions(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? _EmptyShelf(onAdd: () => _openAdd(context))
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: .78),
                    itemBuilder: (context, index) => _GridItemTile(
                      item: items[index],
                      schedule: repository.scheduleFor(items[index].id),
                      onTap: () => _openEdit(context, items[index]),
                      onLongPress: () => _showItemOptions(items[index]),
                      onActiveChanged: (active) =>
                          repository.setPaused(items[index].id, !active),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<RoutineItem> _visibleItems(
      List<RoutineItem> source, dynamic repository) {
    final query = _query.trim().toLowerCase();
    final result = source.where((item) {
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          (item.description ?? '').toLowerCase().contains(query);
      final matchesCategory = switch (_category) {
        'All' => true,
        'Skincare' => item.category == RoutineCategory.skincare,
        'Medication' => item.category == RoutineCategory.medication,
        'Hydration' => item.category == RoutineCategory.hydration,
        'Wellness' => item.category == RoutineCategory.wellness,
        'Household' => item.category == RoutineCategory.household,
        'Other' => item.category == RoutineCategory.custom,
        _ => true,
      };
      return matchesQuery && matchesCategory;
    }).toList();
    if (_sort == 'Name')
      result
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    if (_sort == 'Active first')
      result
          .sort((a, b) => a.isPaused == b.isPaused ? 0 : (a.isPaused ? 1 : -1));
    return result;
  }

  void _openAdd(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) =>
                AddPage(onSaved: () => Navigator.of(context).pop())),
      );

  void _openEdit(BuildContext context, RoutineItem item) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ItemDetailPage(item: item)));

  Future<void> _showShelfOptions() async {
    final selected =
        await showModalBottomSheet<({String sort, String category})>(
      context: context,
      showDragHandle: true,
      builder: (_) => _ShelfOptionsSheet(sort: _sort, category: _category),
    );
    if (selected != null) {
      setState(() {
        _sort = selected.sort;
        _category = selected.category;
      });
    }
  }

  Future<void> _showItemOptions(RoutineItem item) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => _ChoiceSheet(
          title: item.name,
          options: const ['Edit item', 'Archive item'],
          selected: ''),
    );
    if (!mounted) return;
    if (action == 'Edit item') _openEdit(context, item);
    if (action == 'Archive item') {
      await ref.read(routineRepositoryProvider).archive(item.id);
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Item archived')));
    }
  }
}

class _GridItemTile extends StatelessWidget {
  const _GridItemTile(
      {required this.item,
      required this.schedule,
      required this.onTap,
      required this.onLongPress,
      required this.onActiveChanged});
  final RoutineItem item;
  final RoutineSchedule? schedule;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onActiveChanged;

  @override
  Widget build(BuildContext context) => Card(
      child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color:
                                    AppColors.babyPink.withValues(alpha: .48),
                                borderRadius: BorderRadius.circular(13)),
                            child: item.photoPath != null &&
                                    File(item.photoPath!).existsSync()
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(13),
                                    child: Image.file(File(item.photoPath!),
                                        fit: BoxFit.cover))
                                : CategoryIllustration(
                                    category: item.category, size: 70))),
                    const SizedBox(height: 7),
                    Text(item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    Text(_categoryLabel(item.category),
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.mutedBrown)),
                    Row(children: [
                      Expanded(
                          child: Text(_scheduleLabel(schedule),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 9, color: AppColors.mutedBrown))),
                      Switch(
                          value: !item.isPaused,
                          onChanged: onActiveChanged,
                          activeThumbColor: AppColors.successGreen,
                          activeTrackColor:
                              AppColors.successGreen.withValues(alpha: .35))
                    ])
                  ]))));
}

class _ItemTile extends StatelessWidget {
  const _ItemTile(
      {required this.item,
      required this.schedule,
      required this.onTap,
      required this.onLongPress,
      required this.onActiveChanged});
  final RoutineItem item;
  final RoutineSchedule? schedule;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onActiveChanged;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: Row(
              children: [
                Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        color: AppColors.babyPink.withValues(alpha: .48),
                        borderRadius: BorderRadius.circular(13)),
                    child: CategoryIllustration(
                        category: item.category, size: 44)),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(
                          '${_categoryLabel(item.category)} • ${_scheduleLabel(schedule)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.mutedBrown))
                    ])),
                Switch(
                    value: !item.isPaused,
                    onChanged: onActiveChanged,
                    activeThumbColor: AppColors.successGreen,
                    activeTrackColor:
                        AppColors.successGreen.withValues(alpha: .35)),
              ],
            ),
          ),
        ),
      );
}

class _ShelfOptionsSheet extends StatefulWidget {
  const _ShelfOptionsSheet({required this.sort, required this.category});
  final String sort;
  final String category;

  @override
  State<_ShelfOptionsSheet> createState() => _ShelfOptionsSheetState();
}

class _ShelfOptionsSheetState extends State<_ShelfOptionsSheet> {
  late String _sort = widget.sort;
  late String _category = widget.category;

  static const _sortOptions = ['Recently added', 'Name', 'Active first'];
  static const _categoryOptions = [
    'All',
    'Skincare',
    'Medication',
    'Hydration',
    'Wellness',
    'Household',
    'Other'
  ];

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Sort and filter shelf',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Sort by',
                    style: TextStyle(fontWeight: FontWeight.w700))),
            Wrap(
                spacing: 8,
                children: _sortOptions
                    .map((value) => ChoiceChip(
                        label: Text(value),
                        selected: _sort == value,
                        onSelected: (_) => setState(() => _sort = value)))
                    .toList()),
            const SizedBox(height: 8),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Category',
                    style: TextStyle(fontWeight: FontWeight.w700))),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _categoryOptions
                  .map((value) => ChoiceChip(
                      label: Text(value),
                      selected: _category == value,
                      onSelected: (_) => setState(() => _category = value)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context)
                      .pop((sort: _sort, category: _category)),
                  child: const Text('Apply'),
                )),
          ])));
}

class _ChoiceSheet extends StatelessWidget {
  const _ChoiceSheet(
      {required this.title, required this.options, required this.selected});
  final String title;
  final List<String> options;
  final String selected;

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                ...options.map((option) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option),
                    leading: Icon(
                        option == selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: option == selected
                            ? AppColors.rosePink
                            : AppColors.mutedBrown),
                    onTap: () => Navigator.pop(context, option)))
              ])));
}

class _EmptyShelf extends StatelessWidget {
  const _EmptyShelf({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.favorite_border_rounded,
                size: 48, color: AppColors.rosePink),
            const SizedBox(height: 12),
            const Text('Your shelf is ready for its first little routine.',
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onAdd, child: const Text('Add an item'))
          ])));
}

String _categoryLabel(RoutineCategory category) => switch (category) {
      RoutineCategory.skincare => 'Skincare',
      RoutineCategory.medication => 'Medication',
      RoutineCategory.hydration => 'Hydration',
      RoutineCategory.wellness => 'Wellness',
      RoutineCategory.household => 'Household',
      RoutineCategory.custom => 'Other'
    };

String _scheduleLabel(RoutineSchedule? schedule) {
  if (schedule == null) return 'No schedule';
  return switch (schedule.kind) {
    ScheduleKind.daily => schedule.timeSlots.length > 1
        ? '${schedule.timeSlots.length} times daily'
        : 'Daily',
    ScheduleKind.selectedWeekdays => 'Selected days',
    ScheduleKind.interval => 'Every ${schedule.intervalDays} days',
    ScheduleKind.oneTime => 'One-time',
    ScheduleKind.noSchedule => 'No schedule',
  };
}
