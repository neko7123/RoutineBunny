import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/app_providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/scheduling/occurrence.dart';
import '../../core/storage/temporary_task_store.dart';
import '../../core/storage/routine_repository.dart';
import '../../core/notifications/notification_permission_service.dart';
import '../../shared/widgets/bunny_mascot.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});
  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _selected = DateUtils.dateOnly(DateTime.now());
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final occurrences = ref.watch(occurrencesForDateProvider(_selected));
    final temporary = ref.watch(temporaryTaskStoreProvider).forDate(_selected);
    return Scaffold(
        appBar: AppBar(
            title: const Text('Calendar'),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                  onPressed: () => setState(() {
                        _month = DateTime.now();
                        _selected = DateUtils.dateOnly(DateTime.now());
                      }),
                  icon: const Icon(Icons.today_outlined))
            ]),
        body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
            children: [
              _monthHeader(),
              _calendarGrid(),
              const SizedBox(height: 16),
              Text(DateFormat('EEE, d MMM yyyy').format(_selected),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800)),
              occurrences.when(
                  loading: () => const Padding(
                      padding: EdgeInsets.all(22),
                      child: Center(child: CircularProgressIndicator())),
                  error: (error, _) => Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Could not load this day: $error')),
                  data: (items) => _dayDetails(items, temporary))
            ]));
  }

  Widget _monthHeader() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
            onPressed: () => setState(
                () => _month = DateTime(_month.year, _month.month - 1)),
            icon: const Icon(Icons.chevron_left)),
        Text(DateFormat('MMMM yyyy').format(_month),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        IconButton(
            onPressed: () => setState(
                () => _month = DateTime(_month.year, _month.month + 1)),
            icon: const Icon(Icons.chevron_right))
      ]);

  Widget _calendarGrid() {
    final first = DateTime(_month.year, _month.month, 1).weekday;
    final last = DateTime(_month.year, _month.month + 1, 0).day;
    final cells = <Widget>[];
    for (final label in const [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ]) {
      cells.add(Center(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.mutedBrown,
                  fontWeight: FontWeight.w700))));
    }
    for (var index = 1; index < first; index++) {
      cells.add(const SizedBox());
    }
    for (var day = 1; day <= last; day++) {
      final date = DateTime(_month.year, _month.month, day);
      cells.add(_DayCell(
          date: date,
          selected: DateUtils.isSameDay(_selected, date),
          onTap: _openDayDetail));
    }
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox());
    }
    return Card(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
            child: GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 3,
                children: cells)));
  }

  void _openDayDetail(DateTime date) {
    setState(() => _selected = date);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CalendarDayDetailPage(date: date)));
  }

  Widget _dayDetails(
      List<RoutineOccurrence> items, List<TemporaryTask> temporary) {
    if (items.isEmpty && temporary.isEmpty)
      return const Card(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Nothing planned for this day yet.')));
    final completed = items
            .where((item) => item.status == OccurrenceStatus.completed)
            .length +
        temporary.where((task) => task.completed).length;
    final total = items
            .where((item) =>
                item.status != OccurrenceStatus.cancelled &&
                item.status != OccurrenceStatus.skipped)
            .length +
        temporary.length;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$completed of $total completed',
          style: const TextStyle(fontSize: 11, color: AppColors.mutedBrown)),
      ...items.map((item) => _OccurrenceTile(item: item)),
      ...temporary.map((task) => _TemporaryTile(task: task))
    ]);
  }
}

class CalendarDayDetailPage extends ConsumerWidget {
  const CalendarDayDetailPage({super.key, required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occurrences =
        ref.watch(occurrencesForDateProvider(DateUtils.dateOnly(date)));
    final temporary = ref.watch(temporaryTaskStoreProvider).forDate(date);
    return Scaffold(
        appBar: AppBar(
            title: Text(DateFormat('EEE, d MMM yyyy').format(date)),
            backgroundColor: Colors.transparent),
        body: occurrences.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Could not load this day: $error')),
            data: (items) => _detailBody(items, temporary)));
  }

  Widget _detailBody(
          List<RoutineOccurrence> items, List<TemporaryTask> temporary) =>
      DefaultTabController(
          length: 3,
          child: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                    SliverToBoxAdapter(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                            child: Column(children: [
                              const BunnyMascot(size: 112),
                              Card(
                                  color: const Color(0xFFFFF0EE),
                                  child: const Padding(
                                      padding: EdgeInsets.all(13),
                                      child: Text(
                                          'You did your best today!\nConsistency is a form of self-love. ♡',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 11, height: 1.35))))
                            ]))),
                    SliverPersistentHeader(
                        pinned: true, delegate: _TabHeaderDelegate())
                  ],
              body: TabBarView(children: [
                _plannedList(items, temporary),
                _extrasList(temporary),
                const Center(child: Text('No notes added for this day yet.'))
              ])));
  Widget _plannedList(
          List<RoutineOccurrence> items, List<TemporaryTask> temporary) =>
      ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 110), children: [
        ...items.map((item) => _DetailOccurrenceTile(item: item)),
        ...temporary.map((task) => _DetailTemporaryTile(task: task))
      ]);
  Widget _extrasList(List<TemporaryTask> tasks) => tasks.isEmpty
      ? const Center(child: Text('No extras added for this day.'))
      : ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children:
              tasks.map((task) => _DetailTemporaryTile(task: task)).toList());
}

class _TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
          color: AppColors.cream,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const TabBar(isScrollable: true, tabs: [
            Tab(text: 'Planned'),
            Tab(text: 'Extras'),
            Tab(text: 'Notes')
          ]));
  @override
  bool shouldRebuild(covariant _TabHeaderDelegate oldDelegate) => false;
}

class _DayCell extends ConsumerWidget {
  const _DayCell(
      {required this.date, required this.selected, required this.onTap});
  final DateTime date;
  final bool selected;
  final ValueChanged<DateTime> onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(occurrencesForDateProvider(date)).valueOrNull ??
        const <RoutineOccurrence>[];
    final complete =
        data.any((item) => item.status == OccurrenceStatus.completed);
    final attention = data.any((item) =>
        item.status == OccurrenceStatus.missed ||
        item.status == OccurrenceStatus.skipped);
    return InkWell(
        onTap: () => onTap(date),
        borderRadius: BorderRadius.circular(18),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color:
                      selected ? AppColors.strawberryPink : Colors.transparent,
                  shape: BoxShape.circle),
              child: Text('${date.day}',
                  style: TextStyle(
                      fontSize: 11,
                      color: selected ? Colors.white : AppColors.cocoaBrown,
                      fontWeight:
                          selected ? FontWeight.w800 : FontWeight.w500))),
          if (data.isNotEmpty) _dotRow(complete, attention)
        ]));
  }

  Widget _dotRow(bool complete, bool attention) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (complete) _dot(AppColors.successGreen),
        if (attention) _dot(AppColors.errorRose),
        if (!complete && !attention) _dot(AppColors.warningOrange)
      ]);
  Widget _dot(Color color) => Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

class _OccurrenceTile extends ConsumerWidget {
  const _OccurrenceTile({required this.item});
  final RoutineOccurrence item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref
            .read(routineRepositoryProvider)
            .items
            .where((value) => value.id == item.itemId)
            .firstOrNull
            ?.name ??
        'Routine';
    final status = _status(item.status);
    return Card(
        margin: const EdgeInsets.only(top: 8),
        child: ListTile(
            onTap: () => _showCalendarActions(
                context, ref.read(routineRepositoryProvider), item),
            dense: true,
            leading: CircleAvatar(
                radius: 15,
                backgroundColor: status.color.withValues(alpha: .14),
                child: Icon(status.icon, size: 16, color: status.color)),
            title: Text(name,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            subtitle: Text(
                '${DateFormat('h:mm a').format(item.scheduledAt)} · ${status.label}',
                style: TextStyle(fontSize: 10, color: status.color)),
            trailing: const Icon(Icons.chevron_right,
                size: 17, color: AppColors.mutedBrown)));
  }
}

class _TemporaryTile extends StatelessWidget {
  const _TemporaryTile({required this.task});
  final TemporaryTask task;
  @override
  Widget build(BuildContext context) => Card(
      margin: const EdgeInsets.only(top: 8),
      child: ListTile(
          dense: true,
          leading: CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.softLavender,
              child: const Icon(Icons.bolt_outlined,
                  size: 16, color: AppColors.rosePink)),
          title: Text(task.name,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          subtitle: const Text('Extra · This day only',
              style: TextStyle(fontSize: 10, color: AppColors.mutedBrown)),
          trailing: Icon(
              task.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.completed
                  ? AppColors.successGreen
                  : AppColors.borderPink)));
}

class _DetailOccurrenceTile extends ConsumerWidget {
  const _DetailOccurrenceTile({required this.item});
  final RoutineOccurrence item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref
            .read(routineRepositoryProvider)
            .items
            .where((value) => value.id == item.itemId)
            .firstOrNull
            ?.name ??
        'Routine';
    final status = _status(item.status);
    return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
            onTap: () => _showCalendarActions(
                context, ref.read(routineRepositoryProvider), item),
            leading: SizedBox(
                width: 47,
                child: Text(DateFormat('h:mm a').format(item.scheduledAt),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700))),
            title: Row(children: [
              CircleAvatar(
                  radius: 12,
                  backgroundColor: status.color.withValues(alpha: .14),
                  child: Icon(status.icon, size: 13, color: status.color)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700)))
            ]),
            subtitle: Padding(
                padding: const EdgeInsets.only(left: 55),
                child: Text(status.label,
                    style: TextStyle(fontSize: 10, color: status.color))),
            trailing: Icon(status.icon, size: 18, color: status.color)));
  }
}

Future<void> _showCalendarActions(BuildContext context,
    RoutineRepository repository, RoutineOccurrence occurrence) async {
  final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
                title: const Text('Mark as done'),
                onTap: () => Navigator.of(sheetContext).pop('done')),
            ListTile(
                title: const Text('Skip'),
                onTap: () => Navigator.of(sheetContext).pop('skip')),
            ListTile(
                title: const Text('Snooze 10 minutes'),
                onTap: () => Navigator.of(sheetContext).pop('snooze')),
            ListTile(
                title: const Text('Reschedule'),
                onTap: () => Navigator.of(sheetContext).pop('reschedule')),
            ListTile(
                title: const Text('Cancel reminder'),
                onTap: () => Navigator.of(sheetContext).pop('cancel'))
          ])));
  if (action == null || !context.mounted) return;
  final status = switch (action) {
    'done' => OccurrenceStatus.completed,
    'skip' => OccurrenceStatus.skipped,
    'snooze' => OccurrenceStatus.snoozed,
    'cancel' => OccurrenceStatus.cancelled,
    _ => OccurrenceStatus.rescheduled
  };
  if (action == 'reschedule') {
    final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(occurrence.scheduledAt));
    if (time == null || !context.mounted) return;
    await repository.setStatus(occurrence, status,
        scheduledAt: DateTime(
            occurrence.scheduledAt.year,
            occurrence.scheduledAt.month,
            occurrence.scheduledAt.day,
            time.hour,
            time.minute));
    await _reconcileCalendarNotifications(context, repository);
    return;
  }
  await repository.setStatus(occurrence, status,
      scheduledAt: action == 'snooze'
          ? occurrence.scheduledAt.add(const Duration(minutes: 10))
          : null);
  await _reconcileCalendarNotifications(context, repository);
}

Future<void> _reconcileCalendarNotifications(
    BuildContext context, RoutineRepository repository) async {
  if (!context.mounted) return;
  final container = ProviderScope.containerOf(context, listen: false);
  await container
      .read(notificationPermissionServiceProvider)
      .reconcile(repository);
}

class _DetailTemporaryTile extends StatelessWidget {
  const _DetailTemporaryTile({required this.task});
  final TemporaryTask task;
  @override
  Widget build(BuildContext context) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
          leading: SizedBox(
              width: 47,
              child: Text(
                  TimeOfDay(hour: task.hour, minute: task.minute)
                      .format(context),
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700))),
          title: Text(task.name,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          subtitle: const Text('Extra · This day only',
              style: TextStyle(fontSize: 10, color: AppColors.mutedBrown)),
          trailing: Icon(
              task.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.completed
                  ? AppColors.successGreen
                  : AppColors.borderPink)));
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
