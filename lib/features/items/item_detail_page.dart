import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

import '../../app/app_providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/routine_item.dart';
import '../../core/scheduling/occurrence.dart';
import '../../core/scheduling/schedule.dart';
import '../../shared/widgets/category_illustration.dart';
import 'add_page.dart';
import '../../l10n/ui_text.dart';

class ItemDetailPage extends ConsumerStatefulWidget {
  const ItemDetailPage({super.key, required this.item});
  final RoutineItem item;

  @override
  ConsumerState<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends ConsumerState<ItemDetailPage> {
  int _tab = 1;
  DateTime _selected = DateUtils.dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(routineRepositoryProvider);
    final item = repository.items
            .where((value) => value.id == widget.item.id)
            .firstOrNull ??
        widget.item;
    final schedule = repository.scheduleFor(item.id);
    final occurrences = ref.watch(occurrencesForDateProvider(_selected));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        title: Text(item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        actions: [
          PopupMenuButton<int>(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit item',
              onSelected: (step) => _openEditor(item, step),
              itemBuilder: (_) => const [
                    PopupMenuItem(value: 0, child: Text('Item details')),
                    PopupMenuItem(value: 1, child: Text('Schedule')),
                    PopupMenuItem(
                        value: 2, child: Text('Additional information'))
                  ]),
          PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'archive') {
                  await repository.archive(item.id);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              itemBuilder: (_) => const [
                    PopupMenuItem(value: 'archive', child: Text('Archive item'))
                  ]),
        ],
      ),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
          children: [
            _summary(item, schedule),
            const SizedBox(height: 10),
            _additionalInfo(item),
            const SizedBox(height: 14),
            _tabs(),
            const SizedBox(height: 10),
            if (_tab == 0) _scheduleTab(item, schedule),
            if (_tab == 1) ...[
              _calendar(),
              const SizedBox(height: 10),
              _history(item, occurrences)
            ],
            if (_tab == 2) _notes(item),
            if (_tab == 3) _photos(),
          ]),
    );
  }

  Widget _summary(RoutineItem item, RoutineSchedule? schedule) => Card(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                    color: AppColors.babyPink.withValues(alpha: .45),
                    borderRadius: BorderRadius.circular(16)),
                child: item.photoPath != null &&
                        File(item.photoPath!).existsSync()
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(File(item.photoPath!),
                            fit: BoxFit.cover))
                    : CategoryIllustration(category: item.category, size: 82)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _pill(_categoryLabel(item.category), AppColors.rosePink),
                  const SizedBox(height: 9),
                  _meta(Icons.access_time_rounded, _scheduleLabel(schedule),
                      AppColors.cocoaBrown),
                  const SizedBox(height: 7),
                  _meta(
                      Icons.lock_rounded,
                      item.isPaused ? 'Paused' : 'Active',
                      item.isPaused
                          ? AppColors.warningOrange
                          : AppColors.successGreen)
                ]))
          ])));

  Widget _additionalInfo(RoutineItem item) {
    final fields = item.customFields.entries
        .where((entry) =>
            !entry.key.endsWith('__unit') &&
            entry.key != 'status' &&
            entry.key != 'icon' &&
            entry.key != 'color' &&
            entry.value.trim().isNotEmpty)
        .toList();
    if (fields.isEmpty) return const SizedBox.shrink();
    String label(String key) => uiText(
        context,
        switch (key) {
          'brand' => 'brand',
          'expiryDate' => 'expiryDate',
          'usage' => 'usage',
          'size' => 'size',
          'price' => 'price',
          'shelfLocation' => 'shelfNumber',
          _ => key
        });
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Additional information',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ...fields.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    Expanded(
                        child: Text(label(entry.key),
                            style:
                                const TextStyle(color: AppColors.mutedBrown))),
                    Flexible(
                        child: Text(entry.value,
                            textAlign: TextAlign.end,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)))
                  ])))
            ])));
  }

  Widget _tabs() => Row(children: [
        for (final tab in const [
          (name: 'Schedule', value: 0),
          (name: 'History', value: 1),
          (name: 'Notes', value: 2),
          (name: 'Photos', value: 3)
        ])
          Expanded(
              child: InkWell(
                  onTap: () => setState(() => _tab = tab.value),
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: _tab == tab.value
                                      ? AppColors.rosePink
                                      : AppColors.borderPink,
                                  width: _tab == tab.value ? 2 : 1))),
                      child: Text(tab.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              color: _tab == tab.value
                                  ? AppColors.rosePink
                                  : AppColors.mutedBrown,
                              fontWeight: FontWeight.w700)))))
      ]);

  Widget _calendar() {
    final first = DateTime(_selected.year, _selected.month, 1);
    final days = List.generate(
        42,
        (index) => first
            .subtract(Duration(days: first.weekday - 1))
            .add(Duration(days: index)));
    return Card(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 5, 8, 10),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                    onPressed: () => setState(() => _selected =
                        DateTime(_selected.year, _selected.month - 1, 1)),
                    icon: const Icon(Icons.chevron_left)),
                Text(DateFormat('MMMM yyyy').format(_selected),
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                IconButton(
                    onPressed: () => setState(() => _selected =
                        DateTime(_selected.year, _selected.month + 1, 1)),
                    icon: const Icon(Icons.chevron_right))
              ]),
              Row(children: [
                for (final day in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                  Expanded(
                      child: Text(day,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 9, color: AppColors.mutedBrown)))
              ]),
              const SizedBox(height: 4),
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: days.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7, childAspectRatio: 1.3),
                  itemBuilder: (_, index) {
                    final day = days[index];
                    final selected = DateUtils.isSameDay(day, _selected);
                    return InkWell(
                        onTap: () =>
                            setState(() => _selected = DateUtils.dateOnly(day)),
                        child: Center(
                            child: Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected
                                        ? AppColors.strawberryPink
                                        : Colors.transparent),
                                child: Text('${day.day}',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: selected
                                            ? Colors.white
                                            : day.month == _selected.month
                                                ? AppColors.cocoaBrown
                                                : AppColors.borderPink)))));
                  })
            ])));
  }

  Widget _history(
          RoutineItem item, AsyncValue<List<RoutineOccurrence>> value) =>
      value.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('Could not load history: $error'),
          data: (all) {
            final entries = all
                .where((entry) => entry.itemId == item.id)
                .toList()
              ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('EEE, dd MMM yyyy').format(_selected),
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w800)),
                  if (entries.isEmpty)
                    const Card(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No routine history for this day.')))
                  else
                    ...entries.map(_occurrenceTile),
                  const SizedBox(height: 8),
                  SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: () => _showMonthHistory(item),
                          child: const Text('View All History')))
                ]);
          });

  Widget _occurrenceTile(RoutineOccurrence entry) {
    final status = _status(entry.status);
    return Card(
        margin: const EdgeInsets.only(top: 7),
        child: ListTile(
            dense: true,
            leading: SizedBox(
                width: 50,
                child: Text(DateFormat('h:mm a').format(entry.scheduledAt),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700))),
            title: Row(children: [
              CircleAvatar(
                  radius: 11,
                  backgroundColor: status.color.withValues(alpha: .16),
                  child: Icon(status.icon, size: 13, color: status.color)),
              const SizedBox(width: 8),
              Text(status.label,
                  style: TextStyle(
                      fontSize: 11,
                      color: status.color,
                      fontWeight: FontWeight.w700))
            ]),
            trailing: Icon(status.icon, size: 17, color: status.color)));
  }

  Widget _scheduleTab(RoutineItem item, RoutineSchedule? schedule) => Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Current schedule',
                style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(_scheduleLabel(schedule)),
            if (schedule?.timeSlots.isNotEmpty == true)
              Text(schedule!.timeSlots.map(_formatTime).join('  •  '),
                  style: const TextStyle(color: AppColors.mutedBrown)),
            const SizedBox(height: 16),
            OutlinedButton.icon(
                onPressed: () => _openEditor(item, 1),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit schedule'))
          ])));
  Widget _notes(RoutineItem item) => Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(item.description?.isNotEmpty == true
                ? item.description!
                : 'No notes added yet.'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
                onPressed: () => _openEditor(item, 0),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit item details'))
          ])));
  Widget _photos() => Card(
      child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(children: [
            const Icon(Icons.photo_library_outlined,
                size: 34, color: AppColors.rosePink),
            const SizedBox(height: 8),
            const Text('No inventory photos yet.'),
            const SizedBox(height: 10),
            OutlinedButton.icon(
                onPressed: _pickPhoto,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Add photo'))
          ])));

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    CroppedFile? cropped;
    try {
      cropped =
          await ImageCropper().cropImage(sourcePath: picked.path, uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Edit photo',
            toolbarColor: AppColors.rosePink,
            toolbarWidgetColor: Colors.white),
        IOSUiSettings(title: 'Edit photo')
      ]);
    } on PlatformException {
      cropped = CroppedFile(picked.path);
    }
    if (cropped == null) return;
    await ref
        .read(routineRepositoryProvider)
        .save(widget.item.copyWith(photoPath: cropped.path));
    if (mounted) setState(() {});
  }

  void _openEditor(RoutineItem item, int step) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AddPage(
              item: item,
              initialStep: step,
              onSaved: () => Navigator.of(context).pop())));

  Future<void> _showMonthHistory(RoutineItem item) async {
    final start = DateTime(_selected.year, _selected.month, 1);
    final total = DateTime(_selected.year, _selected.month + 1, 0).day;
    final history = <RoutineOccurrence>[];
    for (var day = 0; day < total; day++) {
      final entries = await ref
          .read(routineRepositoryProvider)
          .occurrencesFor(start.add(Duration(days: day)));
      history.addAll(entries.where((entry) => entry.itemId == item.id));
    }
    if (!mounted) return;
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (_) => SafeArea(
                child: ListView(padding: const EdgeInsets.all(16), children: [
              Text('${item.name} history',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800)),
              ...history.map((entry) {
                final status = _status(entry.status);
                return ListTile(
                    dense: true,
                    leading: Text(
                        DateFormat('dd MMM').format(entry.scheduledAt),
                        style: const TextStyle(fontSize: 10)),
                    title: Text(DateFormat('h:mm a').format(entry.scheduledAt)),
                    trailing: Text(status.label,
                        style: TextStyle(color: status.color, fontSize: 11)));
              })
            ])));
  }

  Widget _pill(String text, Color color) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
          color: color.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(20)),
      child: Text(text,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w700)));
  Widget _meta(IconData icon, String text, Color color) => Row(children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
                fontSize: 11, color: color, fontWeight: FontWeight.w600))
      ]);
}

({String label, IconData icon, Color color}) _status(OccurrenceStatus status) =>
    switch (status) {
      OccurrenceStatus.completed => (
          label: 'Completed',
          icon: Icons.check,
          color: AppColors.successGreen
        ),
      OccurrenceStatus.skipped => (
          label: 'Skipped',
          icon: Icons.close,
          color: AppColors.errorRose
        ),
      OccurrenceStatus.missed => (
          label: 'Missed',
          icon: Icons.priority_high,
          color: AppColors.errorRose
        ),
      OccurrenceStatus.snoozed => (
          label: 'Snoozed',
          icon: Icons.alarm,
          color: AppColors.warningOrange
        ),
      OccurrenceStatus.rescheduled => (
          label: 'Rescheduled',
          icon: Icons.calendar_month,
          color: Colors.blue
        ),
      OccurrenceStatus.cancelled => (
          label: 'Cancelled',
          icon: Icons.remove_circle_outline,
          color: AppColors.mutedBrown
        ),
      OccurrenceStatus.pending => (
          label: 'Pending',
          icon: Icons.radio_button_unchecked,
          color: AppColors.mutedBrown
        )
    };
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
    ScheduleKind.noSchedule => 'No schedule'
  };
}

String _formatTime(TimeSlot slot) {
  final hour = slot.hour % 12 == 0 ? 12 : slot.hour % 12;
  return '$hour:${slot.minute.toString().padLeft(2, '0')} ${slot.hour >= 12 ? 'PM' : 'AM'}';
}
