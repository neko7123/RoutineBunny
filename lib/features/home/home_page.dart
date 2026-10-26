import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/app_providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/routine_item.dart';
import '../../core/motivation/motivation_quote_service.dart';
import '../../core/notifications/notification_permission_service.dart';
import '../../core/scheduling/occurrence.dart';
import '../../core/storage/routine_repository.dart';
import '../../core/storage/temporary_task_store.dart';
import '../../shared/widgets/bunny_mascot.dart';
import '../items/item_detail_page.dart';
import '../../l10n/ui_text.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  DateTime _selectedDate = DateTime.now();
  String _filter = 'All';
  final Map<String, String> _notes = {};

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(preferencesStoreProvider).username ?? 'friend';
    final repository = ref.watch(routineRepositoryProvider);
    final temporaryTasks = ref.watch(temporaryTaskStoreProvider);
    final dayTasks = temporaryTasks.forDate(_selectedDate);
    final occurrences = ref
            .watch(occurrencesForDateProvider(_dateOnly(_selectedDate)))
            .valueOrNull ??
        const <RoutineOccurrence>[];
    final quote = ref.watch(motivationQuoteProvider);
    final progress = calculateProgress(occurrences);
    final isToday = DateUtils.isSameDay(_selectedDate, DateTime.now());
    final greeting = isToday
        ? '${_timeGreeting(DateTime.now())}, $username! ♡'
        : 'Planning your ${DateFormat('EEEE').format(_selectedDate)}';
    return Scaffold(
      body: SafeArea(
          child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
              children: [
            Row(children: [
              Expanded(
                  child: Text(greeting,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800))),
              const BunnyMascot(size: 76, expression: 'happy')
            ]),
            Text(DateFormat('EEE, d MMM yyyy').format(_selectedDate),
                style: const TextStyle(color: AppColors.mutedBrown)),
            const SizedBox(height: 10),
            _motivationCard(quote),
            const SizedBox(height: 14),
            _dateStrip(),
            const SizedBox(height: 18),
            _progressCard(context, progress),
            const SizedBox(height: 18),
            SizedBox(
                height: 42,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      'All',
                      'Morning',
                      'Afternoon',
                      'Evening',
                      'Anytime'
                    ]
                        .map((filter) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                                label: Text(_filterLabel(context, filter)),
                                selected: _filter == filter,
                                onSelected: (_) =>
                                    setState(() => _filter = filter),
                                selectedColor: AppColors.babyPink)))
                        .toList())),
            const SizedBox(height: 14),
            Text(isToday ? 'To-Do' : 'Planned for this day',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            if (occurrences.isEmpty)
              const Card(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                          'No routines planned for this day yet. Add one whenever you are ready.'))),
            ...occurrences.where(_matchesFilter).map((occurrence) {
              final item = repository.items
                  .where((value) => value.id == occurrence.itemId)
                  .firstOrNull;
              return item == null
                  ? const SizedBox.shrink()
                  : _activityCard(context, repository, item, occurrence);
            }),
            ...dayTasks.map(_temporaryTaskCard),
            const SizedBox(height: 6),
            FilledButton.icon(
                onPressed: () => _addTemporaryTask(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add to this day'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.strawberryPink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)))),
          ])),
    );
  }

  bool _matchesFilter(RoutineOccurrence occurrence) {
    final hour = occurrence.scheduledAt.hour;
    return switch (_filter) {
      'Morning' => hour < 12,
      'Afternoon' => hour >= 12 && hour < 17,
      'Evening' => hour >= 17 && hour < 21,
      'Anytime' => true,
      _ => true,
    };
  }

  String _filterLabel(BuildContext context, String filter) => switch (filter) {
        'All' => uiText(context, 'all'),
        'Morning' => uiText(context, 'morning'),
        'Afternoon' => uiText(context, 'afternoon'),
        'Evening' => uiText(context, 'evening'),
        'Anytime' => uiText(context, 'anytime'),
        _ => filter
      };

  Widget _dateStrip() => SizedBox(
      height: 82,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            final date = DateTime.now().add(Duration(days: index - 2));
            final selected = DateUtils.isSameDay(date, _selectedDate);
            return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                    width: 58,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: selected
                            ? AppColors.strawberryPink
                            : AppColors.softWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selected
                                ? AppColors.strawberryPink
                                : AppColors.borderPink)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat('EEE').format(date).substring(0, 2),
                              style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.mutedBrown,
                                  fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${date.day}',
                              style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.cocoaBrown,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18))
                        ])));
          }));

  Widget _motivationCard(AsyncValue<MotivationQuote> quote) => Card(
      color: const Color(0xFFFFF0EE),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderPink)),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: quote.when(
              loading: () => const SizedBox(
                  height: 38,
                  child: Center(
                      child: LinearProgressIndicator(
                          minHeight: 3,
                          color: AppColors.strawberryPink,
                          backgroundColor: AppColors.babyPink))),
              error: (_, __) => _quoteText(MotivationQuoteService.fallback),
              data: _quoteText)));

  Widget _quoteText(MotivationQuote value) => Row(children: [
        const BunnyMascot(size: 48, expression: 'happy'),
        const SizedBox(width: 8),
        Expanded(
            child: Text('“${value.text}”',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: AppColors.cocoaBrown)))
      ]);

  Widget _progressCard(BuildContext context, ProgressSummary progress) => Card(
      color: AppColors.babyPink,
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const BunnyMascot(size: 58, expression: 'encouraging'),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Today’s Progress',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  Text(
                      progress.hasActivities
                          ? '${progress.completed} of ${progress.denominator} completed'
                          : 'A fresh day for little wins',
                      style: const TextStyle(color: AppColors.mutedBrown)),
                  const SizedBox(height: 9),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                          value: progress.hasActivities ? progress.fraction : 0,
                          minHeight: 9,
                          backgroundColor: Colors.white70,
                          color: AppColors.strawberryPink))
                ]))
          ])));

  Widget _activityCard(BuildContext context, RoutineRepository repository,
      RoutineItem item, RoutineOccurrence occurrence) {
    final done = occurrence.status == OccurrenceStatus.completed;
    final time = DateFormat('h:mm a').format(occurrence.scheduledAt);
    final status = _statusLabel(occurrence.status);
    final note = ref.watch(preferencesStoreProvider).noteFor(occurrence.id) ??
        _notes[occurrence.id];
    return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () =>
                _showRoutineActions(context, repository, item, occurrence),
            child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: _tint(item.category),
                    foregroundColor: AppColors.rosePink,
                    child: Icon(_icon(item.category))),
                title: Text(item.name,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(note ??
                    (status == null
                        ? '$time · ${item.category.name}'
                        : '$time · $status')),
                trailing: Icon(
                    done ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: done
                        ? AppColors.successGreen
                        : AppColors.borderPink))));
  }

  Future<void> _showRoutineActions(
      BuildContext context,
      RoutineRepository repository,
      RoutineItem item,
      RoutineOccurrence occurrence) async {
    final action = await showModalBottomSheet<_RoutineAction>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.borderPink,
                      borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 10),
              ListTile(
                  title: Text(item.name,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(DateFormat('h:mm a · EEE, d MMM')
                      .format(occurrence.scheduledAt)),
                  leading: CircleAvatar(
                      backgroundColor: AppColors.babyPink,
                      foregroundColor: AppColors.rosePink,
                      child: Icon(_icon(item.category))),
                  trailing: IconButton(
                      tooltip: 'Close',
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop())),
              _actionTile(
                  context,
                  _RoutineAction.itemDetails,
                  Icons.inventory_2_outlined,
                  'View Item Details',
                  AppColors.rosePink),
              _actionTile(context, _RoutineAction.complete, Icons.check_circle,
                  'Mark as Done', AppColors.successGreen),
              _actionTile(context, _RoutineAction.skip, Icons.close, 'Skip',
                  AppColors.errorRose),
              _actionTile(context, _RoutineAction.snooze, Icons.alarm, 'Snooze',
                  AppColors.warningOrange),
              _actionTile(context, _RoutineAction.reschedule,
                  Icons.calendar_month, 'Reschedule', Colors.blue),
              _actionTile(context, _RoutineAction.note, Icons.edit_note,
                  'Add Note', Colors.deepPurple),
              _actionTile(context, _RoutineAction.cancel,
                  Icons.remove_circle_outline, 'Cancel', AppColors.mutedBrown),
            ])));
    if (!mounted || action == null) return;
    switch (action) {
      case _RoutineAction.complete:
        await repository.setStatus(occurrence, OccurrenceStatus.completed);
      case _RoutineAction.skip:
        await repository.setStatus(occurrence, OccurrenceStatus.skipped);
      case _RoutineAction.snooze:
        await repository.setStatus(occurrence, OccurrenceStatus.snoozed,
            scheduledAt:
                occurrence.scheduledAt.add(const Duration(minutes: 10)));
      case _RoutineAction.reschedule:
        final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(occurrence.scheduledAt));
        if (time != null)
          await repository.setStatus(occurrence, OccurrenceStatus.rescheduled,
              scheduledAt: DateTime(
                  occurrence.scheduledAt.year,
                  occurrence.scheduledAt.month,
                  occurrence.scheduledAt.day,
                  time.hour,
                  time.minute));
      case _RoutineAction.note:
        final note = await _askForNote(context);
        if (note != null && note.trim().isNotEmpty) {
          setState(() => _notes[occurrence.id] = note.trim());
          await ref
              .read(preferencesStoreProvider)
              .setNote(occurrence.id, note.trim());
        }
      case _RoutineAction.cancel:
        await repository.setStatus(occurrence, OccurrenceStatus.cancelled);
      case _RoutineAction.itemDetails:
        await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ItemDetailPage(item: item)));
    }
    await ref.read(notificationPermissionServiceProvider).reconcile(repository);
  }

  Widget _actionTile(BuildContext context, _RoutineAction action, IconData icon,
          String label, Color color) =>
      Card(
          margin: const EdgeInsets.only(bottom: 7),
          color: color.withValues(alpha: .12),
          child: ListTile(
              dense: true,
              leading: CircleAvatar(
                  radius: 15,
                  backgroundColor: color,
                  child: Icon(icon, size: 17, color: Colors.white)),
              title: Text(label,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700)),
              onTap: () => Navigator.pop(context, action)));

  Future<String?> _askForNote(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Add Note'),
                content: TextField(
                    controller: controller,
                    autofocus: true,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(hintText: 'How did it go?')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, controller.text),
                      child: const Text('Save'))
                ]));
    controller.dispose();
    return result;
  }

  Widget _temporaryTaskCard(TemporaryTask task) {
    final time =
        TimeOfDay(hour: task.hour, minute: task.minute).format(context);
    return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
            leading: CircleAvatar(
                backgroundColor: AppColors.softLavender,
                foregroundColor: AppColors.rosePink,
                child: const Icon(Icons.bolt_outlined)),
            title: Text(task.name,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('$time · This day only'),
            trailing: IconButton(
                onPressed: () => ref
                    .read(temporaryTaskStoreProvider)
                    .setCompleted(task, !task.completed),
                icon: Icon(
                    task.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task.completed
                        ? AppColors.successGreen
                        : AppColors.borderPink))));
  }

  Future<void> _addTemporaryTask(BuildContext context) async {
    final result = await showDialog<_TemporaryTaskDraft>(
        context: context,
        builder: (_) => _TemporaryTaskDialog(date: _selectedDate));
    if (!mounted || result == null || result.name.trim().isEmpty) return;
    await ref
        .read(temporaryTaskStoreProvider)
        .add(date: _selectedDate, name: result.name.trim(), time: result.time);
  }

  static String? _statusLabel(OccurrenceStatus status) => switch (status) {
        OccurrenceStatus.pending => null,
        OccurrenceStatus.completed => 'Completed',
        OccurrenceStatus.skipped => 'Skipped',
        OccurrenceStatus.missed => 'Missed',
        OccurrenceStatus.snoozed => 'Snoozed',
        OccurrenceStatus.rescheduled => 'Rescheduled',
        OccurrenceStatus.cancelled => 'Cancelled'
      };
  static IconData _icon(RoutineCategory value) => switch (value) {
        RoutineCategory.skincare => Icons.spa_outlined,
        RoutineCategory.medication => Icons.medication_outlined,
        RoutineCategory.hydration => Icons.water_drop_outlined,
        RoutineCategory.wellness => Icons.self_improvement_outlined,
        RoutineCategory.household => Icons.home_outlined,
        RoutineCategory.custom => Icons.favorite_border
      };
  static Color _tint(RoutineCategory value) => switch (value) {
        RoutineCategory.skincare => AppColors.softPeach,
        RoutineCategory.medication => AppColors.babyPink,
        RoutineCategory.hydration => AppColors.softLavender,
        RoutineCategory.wellness => AppColors.softPeach,
        RoutineCategory.household => AppColors.babyPink,
        RoutineCategory.custom => AppColors.softLavender
      };
  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
  static String _timeGreeting(DateTime now) => now.hour < 12
      ? 'Good morning'
      : now.hour < 17
          ? 'Good afternoon'
          : now.hour < 21
              ? 'Good evening'
              : 'Good night';
}

class _TemporaryTaskDraft {
  const _TemporaryTaskDraft(this.name, this.time);
  final String name;
  final TimeOfDay time;
}

class _TemporaryTaskDialog extends StatefulWidget {
  const _TemporaryTaskDialog({required this.date});
  final DateTime date;

  @override
  State<_TemporaryTaskDialog> createState() => _TemporaryTaskDialogState();
}

class _TemporaryTaskDialogState extends State<_TemporaryTaskDialog> {
  final _nameController = TextEditingController();
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Add to ${DateFormat('d MMMM').format(widget.date)}'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                  labelText: 'What would you like to do?',
                  hintText: 'e.g. Face mask')),
          const SizedBox(height: 14),
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule, color: AppColors.rosePink),
              title: const Text('Time'),
              subtitle: Text(_time.format(context)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final picked =
                    await showTimePicker(context: context, initialTime: _time);
                if (picked != null && mounted) setState(() => _time = picked);
              })
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(context)
                  .pop(_TemporaryTaskDraft(_nameController.text, _time)),
              child: const Text('Add'))
        ],
      );
}

enum _RoutineAction {
  complete,
  skip,
  snooze,
  reschedule,
  note,
  cancel,
  itemDetails
}
