import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../app/app_providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/routine_item.dart';
import '../../core/scheduling/schedule.dart';
import '../../core/notifications/notification_permission_service.dart';
import '../../l10n/ui_text.dart';

class AddPage extends ConsumerStatefulWidget {
  const AddPage(
      {super.key,
      required this.onSaved,
      this.item,
      this.initialCategory,
      this.initialStep = 0});
  final VoidCallback onSaved;
  final RoutineItem? item;
  final RoutineCategory? initialCategory;
  final int initialStep;
  @override
  ConsumerState<AddPage> createState() => _AddPageState();
}

class _CustomFieldDraft {
  _CustomFieldDraft(this.label, this.unit, String value)
      : controller = TextEditingController(text: value);

  final String label;
  final String unit;
  final TextEditingController controller;

  void dispose() => controller.dispose();
}

class _AddPageState extends ConsumerState<AddPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  RoutineCategory _category = RoutineCategory.custom;
  ScheduleKind _kind = ScheduleKind.daily;
  Set<int> _weekdays = {
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday
  };
  DateTime? _oneTimeDate;
  DateTime? _overrideDate;
  bool _overrideCancelled = false;
  TimeOfDay _overrideTime = const TimeOfDay(hour: 8, minute: 0);
  List<TimeOfDay> _times = [const TimeOfDay(hour: 8, minute: 0)];
  bool _paused = false;
  bool _saving = false;
  late int _step;
  int _intervalDays = 7;
  final _intervalController = TextEditingController(text: '7');
  final _brandController = TextEditingController();
  final _expiryController = TextEditingController();
  final _usageController = TextEditingController();
  final _sizeController = TextEditingController();
  final _priceController = TextEditingController();
  final _shelfController = TextEditingController();
  String _status = 'Active';
  String? _photoPath;
  String _selectedIcon = 'drop';
  int _selectedColor = 0xFFFF8FA3;
  final List<_CustomFieldDraft> _extraFields = [];

  @override
  void initState() {
    super.initState();
    _step = widget.initialStep.clamp(0, 2).toInt();
    final item = widget.item;
    if (item == null) {
      if (widget.initialCategory != null) _category = widget.initialCategory!;
      return;
    }
    _nameController.text = item.name;
    _descriptionController.text = item.description ?? '';
    _category = item.category;
    _photoPath = item.photoPath;
    _paused = item.isPaused;
    _brandController.text = item.customFields['brand'] ?? '';
    _expiryController.text = item.customFields['expiryDate'] ?? '';
    _usageController.text = item.customFields['usage'] ?? '';
    _sizeController.text = item.customFields['size'] ?? '';
    _priceController.text = item.customFields['price'] ?? '';
    _shelfController.text = item.customFields['shelfLocation'] ?? '';
    _status = item.customFields['status'] ?? 'Active';
    _selectedIcon = item.customFields['icon'] ?? 'drop';
    _selectedColor =
        int.tryParse(item.customFields['color'] ?? '') ?? 0xFFFF8FA3;
    for (final entry in item.customFields.entries) {
      if (!entry.key.endsWith('__unit') &&
          !{
            'brand',
            'expiryDate',
            'usage',
            'size',
            'price',
            'shelfLocation',
            'status',
            'icon',
            'color'
          }.contains(entry.key)) {
        _extraFields.add(_CustomFieldDraft(entry.key,
            item.customFields['${entry.key}__unit'] ?? '', entry.value));
      }
    }
    final schedule = ref.read(routineRepositoryProvider).scheduleFor(item.id);
    if (schedule == null) return;
    _kind = schedule.kind;
    _weekdays = {...schedule.weekdays};
    _oneTimeDate = schedule.oneTimeDate;
    _times = schedule.timeSlots
        .map((slot) => TimeOfDay(hour: slot.hour, minute: slot.minute))
        .toList();
    if (_times.isEmpty) _times = [const TimeOfDay(hour: 8, minute: 0)];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _intervalController.dispose();
    _brandController.dispose();
    _expiryController.dispose();
    _usageController.dispose();
    _sizeController.dispose();
    _priceController.dispose();
    _shelfController.dispose();
    for (final field in _extraFields) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text(_step == 0
                ? 'Item Details'
                : _step == 1
                    ? 'Schedule'
                    : 'Additional Information'),
            backgroundColor: Colors.transparent,
            actions: [
              if (widget.item != null)
                IconButton(
                    onPressed: _archive,
                    icon: const Icon(Icons.archive_outlined))
            ]),
        body: _step == 0
            ? _generalDetails()
            : _step == 1
                ? _scheduleDetails()
                : _additionalDetails(),
        bottomNavigationBar: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                child: Row(children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: _step == 0
                              ? () => Navigator.of(context).pop()
                              : () => setState(() => _step--),
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              foregroundColor: AppColors.cocoaBrown,
                              side: const BorderSide(
                                  color: AppColors.borderPink)),
                          child: Text(_step == 0 ? 'Cancel' : 'Back'))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: FilledButton(
                          onPressed: _saving ? null : _nextOrSave,
                          style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: AppColors.strawberryPink),
                          child: Text(_step < 2
                              ? 'Next'
                              : (_saving ? 'Saving...' : 'Save'))))
                ]))),
      );

  void _nextOrSave() {
    if (_step == 0) {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please add a name first.')));
        return;
      }
      setState(() => _step = 1);
    } else if (_step == 1) {
      setState(() => _step = 2);
    } else {
      _save();
    }
  }

  Widget _generalDetails() =>
      ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 18), children: [
        Center(
            child: Container(
                width: 160,
                height: 112,
                decoration: BoxDecoration(
                    color: AppColors.softPeach,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderPink)),
                child: _photoPath != null && File(_photoPath!).existsSync()
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(File(_photoPath!), fit: BoxFit.cover))
                    : const Icon(Icons.add_a_photo_outlined,
                        size: 34, color: AppColors.rosePink))),
        Center(
            child: TextButton(
                onPressed: _pickPhoto,
                child: const Text('Change Photo',
                    style:
                        TextStyle(fontSize: 10, color: AppColors.mutedBrown)))),
        _labelText('Name'),
        TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                hintText: 'Hyaluronic Acid Serum',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 11))),
        const SizedBox(height: 12),
        _labelText('Description'),
        TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
                hintText: 'Deep hydration serum for plump and glowing skin.',
                contentPadding: EdgeInsets.all(12))),
        const SizedBox(height: 12),
        DropdownButtonFormField<RoutineCategory>(
            initialValue: _category,
            decoration: const InputDecoration(
                labelText: 'Category',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 5)),
            items: RoutineCategory.values
                .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(_label(value),
                        style: const TextStyle(fontSize: 12))))
                .toList(),
            onChanged: (value) =>
                setState(() => _category = value ?? RoutineCategory.custom)),
        const SizedBox(height: 14),
        _labelText('Color & Icon'),
        Row(children: [
          for (final choice in const [
            (name: 'drop', icon: Icons.water_drop_outlined),
            (name: 'flower', icon: Icons.local_florist_outlined),
            (name: 'heart', icon: Icons.favorite_border),
            (name: 'sparkle', icon: Icons.auto_awesome_outlined)
          ])
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () => setState(() => _selectedIcon = choice.name),
                    borderRadius: BorderRadius.circular(24),
                    child: CircleAvatar(
                        radius: 22,
                        backgroundColor: _selectedIcon == choice.name
                            ? Color(_selectedColor)
                            : AppColors.babyPink,
                        foregroundColor: _selectedIcon == choice.name
                            ? Colors.white
                            : AppColors.rosePink,
                        child: Icon(choice.icon, size: 20))))
        ]),
      ]);

  Widget _labelText(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text,
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.cocoaBrown)));

  Widget _additionalDetails() =>
      ListView(padding: const EdgeInsets.fromLTRB(18, 6, 18, 18), children: [
        _labelText('Brand'),
        TextField(
            controller: _brandController,
            decoration: const InputDecoration(hintText: 'The Ordinary')),
        const SizedBox(height: 12),
        _labelText('Expiry Date'),
        TextField(
            controller: _expiryController,
            readOnly: true,
            decoration: InputDecoration(
                hintText: '12 Dec 2026',
                suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    onPressed: () async {
                      final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 3650)),
                          initialDate:
                              DateTime.now().add(const Duration(days: 365)));
                      if (picked != null)
                        _expiryController.text =
                            MaterialLocalizations.of(context)
                                .formatMediumDate(picked);
                    }))),
        const SizedBox(height: 12),
        _labelText('Usage Instructions'),
        TextField(
            controller: _usageController,
            maxLines: 3,
            decoration: const InputDecoration(
                hintText: 'Apply 2-3 drops on clean skin.')),
        const SizedBox(height: 14),
        Row(children: [
          const Expanded(
              child: Text('Custom Fields (Optional)',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
          TextButton(
              onPressed: _addCustomField,
              child: const Text('Add Field',
                  style: TextStyle(fontSize: 10, color: AppColors.rosePink)))
        ]),
        Card(
            child: Column(children: [
          _customField('Size', _sizeController, '30', 'ml'),
          const Divider(height: 1),
          _customField(
              'Price',
              _priceController,
              ref.watch(preferencesStoreProvider).currencyCode == 'INR'
                  ? '1200'
                  : '1200',
              ref.watch(preferencesStoreProvider).currencyCode),
          const Divider(height: 1),
          _customField('Shelf Number', _shelfController, '1', ''),
          ..._extraFields.expand((field) => [
                const Divider(height: 1),
                _customField(field.label, field.controller, '', field.unit)
              ])
        ])),
        const SizedBox(height: 14),
        _labelText('Status'),
        _statusOption('Active', 'Will create future reminders',
            Icons.radio_button_checked),
        _statusOption(
            'Paused', 'Temporarily stop reminders', Icons.pause_circle_outline),
        _statusOption('Archived', 'Keep for history, no reminders',
            Icons.archive_outlined),
      ]);

  Widget _customField(String label, TextEditingController controller,
          String hint, String unit) =>
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(children: [
            SizedBox(
                width: 112,
                child: Text(
                    uiText(
                        context,
                        switch (label) {
                          'Size' => 'size',
                          'Price' => 'price',
                          'Shelf Number' => 'shelfNumber',
                          _ => label
                        }),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700))),
            Expanded(
                child: TextField(
                    controller: controller,
                    keyboardType: label == 'Price' || label == 'Shelf Number'
                        ? TextInputType.number
                        : TextInputType.text,
                    decoration:
                        InputDecoration(hintText: hint, isDense: true))),
            if (unit.isNotEmpty)
              SizedBox(
                  width: 48,
                  child: Text(unit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.mutedBrown,
                          fontWeight: FontWeight.w700)))
          ]));

  Future<void> _addCustomField() async {
    final labelController = TextEditingController();
    final unitController = TextEditingController();
    final valueController = TextEditingController();
    final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
                title: const Text('Add custom field'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                      controller: labelController,
                      decoration:
                          const InputDecoration(labelText: 'Field label')),
                  TextField(
                      controller: unitController,
                      decoration: const InputDecoration(labelText: 'Unit')),
                  TextField(
                      controller: valueController,
                      decoration: const InputDecoration(labelText: 'Quantity'))
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text('Add'))
                ]));
    if (result == true && mounted && labelController.text.trim().isNotEmpty) {
      setState(() => _extraFields.add(_CustomFieldDraft(
          labelController.text.trim(),
          unitController.text.trim(),
          valueController.text.trim())));
    }
    labelController.dispose();
    unitController.dispose();
    valueController.dispose();
  }

  Widget _statusOption(String value, String description, IconData icon) =>
      RadioListTile<String>(
          contentPadding: EdgeInsets.zero,
          dense: true,
          value: value,
          groupValue: _status,
          onChanged: (next) => setState(() {
                _status = next ?? 'Active';
                _paused = _status == 'Paused';
              }),
          title: Text(value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          subtitle: Text(description, style: const TextStyle(fontSize: 10)),
          secondary: Icon(icon,
              size: 20,
              color: value == _status
                  ? AppColors.rosePink
                  : AppColors.mutedBrown));

  Widget _repeatControls() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Repeat',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _repeatChip('Recurring', _kind != ScheduleKind.oneTime),
              _repeatChip('One-time', _kind == ScheduleKind.oneTime),
              _repeatChip('Flexible', _kind == ScheduleKind.interval),
              _repeatChip('No Schedule', _kind == ScheduleKind.noSchedule)
            ])),
        const SizedBox(height: 10),
        if (_kind != ScheduleKind.oneTime && _kind != ScheduleKind.noSchedule)
          DropdownButtonFormField<String>(
              initialValue: _repeatLabel(),
              decoration: const InputDecoration(labelText: 'Repeat pattern'),
              items: const [
                DropdownMenuItem(value: 'Every day', child: Text('Every day')),
                DropdownMenuItem(
                    value: 'Selected days', child: Text('Selected days')),
                DropdownMenuItem(
                    value: 'Every 7 days', child: Text('Every 1 week')),
                DropdownMenuItem(
                    value: 'Every 15 days', child: Text('Every 15 days')),
                DropdownMenuItem(
                    value: 'Every 30 days', child: Text('Every 1 month')),
                DropdownMenuItem(
                    value: 'Every 90 days', child: Text('Every 3 months')),
                DropdownMenuItem(
                    value: 'Custom', child: Text('Custom interval'))
              ],
              onChanged: (value) {
                if (value == 'Every day')
                  setState(() => _kind = ScheduleKind.daily);
                else if (value == 'Selected days')
                  setState(() => _kind = ScheduleKind.selectedWeekdays);
                else if (value != null) {
                  final days =
                      int.tryParse(value.replaceAll(RegExp('[^0-9]'), ''));
                  setState(() {
                    _kind = ScheduleKind.interval;
                    _intervalDays = days ?? _intervalDays;
                    _intervalController.text = '$_intervalDays';
                  });
                }
              }),
        if (_kind == ScheduleKind.interval)
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                  controller: _intervalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Repeat every how many days?',
                      suffixText: 'days'),
                  onChanged: (value) =>
                      _intervalDays = int.tryParse(value) ?? 1)),
      ]);

  Widget _repeatChip(String label, bool selected) => Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
          label: Text(label, style: const TextStyle(fontSize: 10)),
          selected: selected,
          selectedColor: AppColors.strawberryPink,
          labelStyle:
              TextStyle(color: selected ? Colors.white : AppColors.cocoaBrown),
          onSelected: (_) {
            if (label == 'One-time')
              setState(() => _kind = ScheduleKind.oneTime);
            if (label == 'Recurring')
              setState(() => _kind = ScheduleKind.daily);
            if (label == 'Flexible')
              setState(() => _kind = ScheduleKind.interval);
            if (label == 'No Schedule')
              setState(() => _kind = ScheduleKind.noSchedule);
          }));

  String _repeatLabel() => switch (_kind) {
        ScheduleKind.daily => 'Every day',
        ScheduleKind.selectedWeekdays => 'Selected days',
        ScheduleKind.oneTime => 'Every day',
        ScheduleKind.noSchedule => 'Every day',
        ScheduleKind.interval => _intervalDays == 7
            ? 'Every 7 days'
            : _intervalDays == 15
                ? 'Every 15 days'
                : _intervalDays == 30
                    ? 'Every 30 days'
                    : _intervalDays == 90
                        ? 'Every 90 days'
                        : 'Custom'
      };

  Widget _scheduleDetails() =>
      ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 18), children: [
        const Text('Schedule & Reminders',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 18),
        _repeatControls(),
        if (_kind == ScheduleKind.selectedWeekdays) _weekdayPicker(),
        if (_kind == ScheduleKind.oneTime) _datePicker(),
        const SizedBox(height: 8),
        ..._times.asMap().entries.map((entry) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
                leading: const Icon(Icons.schedule, color: AppColors.rosePink),
                title: Text(entry.value.format(context)),
                subtitle: Text('Time slot ${entry.key + 1}'),
                onTap: () => _pickTime(entry.key),
                trailing: IconButton(
                    onPressed: _times.length == 1
                        ? null
                        : () => setState(
                            () => _times = [..._times]..removeAt(entry.key)),
                    icon: const Icon(Icons.delete_outline))))),
        TextButton.icon(
            onPressed: () => setState(() =>
                _times = [..._times, const TimeOfDay(hour: 20, minute: 0)]),
            icon: const Icon(Icons.add),
            label: const Text('Add another time')),
        _overrideEditor(),
        SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _paused,
            onChanged: (value) => setState(() => _paused = value),
            title: const Text('Pause reminders'),
            subtitle: const Text(
                'Keep the routine and history, but stop creating active occurrences.'),
            activeThumbColor: AppColors.rosePink),
      ]);

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty ||
        _times.isEmpty ||
        (_kind == ScheduleKind.selectedWeekdays && _weekdays.isEmpty) ||
        (_kind == ScheduleKind.oneTime && _oneTimeDate == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete the schedule first.')));
      return;
    }
    setState(() => _saving = true);
    final repository = ref.read(routineRepositoryProvider);
    final id =
        widget.item?.id ?? 'item_${DateTime.now().microsecondsSinceEpoch}';
    final customFields = <String, String>{
      'brand': _brandController.text.trim(),
      'expiryDate': _expiryController.text.trim(),
      'usage': _usageController.text.trim(),
      'size': _sizeController.text.trim(),
      'price': _priceController.text.trim(),
      'shelfLocation': _shelfController.text.trim(),
      'icon': _selectedIcon,
      'color': '$_selectedColor',
      'status': _status
    };
    for (final field in _extraFields) {
      customFields[field.label] = field.controller.text.trim();
      customFields['${field.label}__unit'] = field.unit;
    }
    await repository.save(RoutineItem(
        id: id,
        name: name,
        category: _category,
        photoPath: _photoPath,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        customFields: customFields,
        isPaused: _paused,
        isArchived: _status == 'Archived'));
    await repository.saveSchedule(
        id,
        RoutineSchedule(
            kind: _kind,
            weekdays: _weekdays,
            timeSlots: _times
                .map((time) => TimeSlot(hour: time.hour, minute: time.minute))
                .toList(),
            oneTimeDate: _oneTimeDate,
            startDate: _kind == ScheduleKind.interval ? DateTime.now() : null,
            intervalDays: _intervalDays));
    await ref.read(notificationPermissionServiceProvider).reconcile(repository);
    if (_overrideDate != null)
      await repository.saveOverride(
          id,
          _overrideDate!,
          ScheduleOverride(
              isCancelled: _overrideCancelled,
              timeSlots: _overrideCancelled
                  ? const []
                  : [
                      TimeSlot(
                          hour: _overrideTime.hour,
                          minute: _overrideTime.minute)
                    ]));
    if (!mounted) return;
    setState(() => _saving = false);
    widget.onSaved();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final pickedPath = picked.path;
    CroppedFile? cropped;
    try {
      cropped =
          await ImageCropper().cropImage(sourcePath: pickedPath, uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Edit photo',
            toolbarColor: AppColors.rosePink,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Edit photo')
      ]);
    } on PlatformException {
      if (mounted) setState(() => _photoPath = pickedPath);
      return;
    }
    if (cropped != null && mounted) {
      final croppedPath = cropped.path;
      setState(() => _photoPath = croppedPath);
    }
  }

  Future<void> _archive() async {
    final item = widget.item;
    if (item == null) return;
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Archive this routine?'),
                content: const Text(
                    'It will leave your active shelf, while its history remains safe.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Keep it')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Archive'))
                ]));
    if (confirmed == true && mounted) {
      await ref.read(routineRepositoryProvider).archive(item.id);
      widget.onSaved();
    }
  }

  Widget _weekdayPicker() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Wrap(
          spacing: 8,
          children: List.generate(7, (index) {
            final day = index + 1;
            return FilterChip(
                label: Text(_weekdayLabel(day)),
                selected: _weekdays.contains(day),
                onSelected: (value) => setState(() => _weekdays = value
                    ? {..._weekdays, day}
                    : ({..._weekdays}..remove(day))));
          })));
  Widget _datePicker() => Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
          leading: const Icon(Icons.event, color: AppColors.rosePink),
          title: Text(_oneTimeDate == null
              ? 'Choose a date'
              : MaterialLocalizations.of(context)
                  .formatMediumDate(_oneTimeDate!)),
          onTap: () async {
            final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
                initialDate: _oneTimeDate ?? DateTime.now());
            if (picked != null) setState(() => _oneTimeDate = picked);
          }));
  Widget _overrideEditor() => Card(
      margin: const EdgeInsets.only(top: 12),
      child: Column(children: [
        ListTile(
            leading: const Icon(Icons.edit_calendar_outlined,
                color: AppColors.rosePink),
            title: const Text('Date-specific override'),
            subtitle: Text(_overrideDate == null
                ? 'Change or skip one date'
                : MaterialLocalizations.of(context)
                    .formatMediumDate(_overrideDate!)),
            onTap: () async {
              final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                  initialDate: _overrideDate ?? DateTime.now());
              if (picked != null) setState(() => _overrideDate = picked);
            }),
        if (_overrideDate != null)
          SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              value: _overrideCancelled,
              onChanged: (value) => setState(() => _overrideCancelled = value),
              title: const Text('Skip this date'),
              activeThumbColor: AppColors.rosePink),
        if (_overrideDate != null && !_overrideCancelled)
          ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: const Text('Override time'),
              trailing: TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                        context: context, initialTime: _overrideTime);
                    if (picked != null) setState(() => _overrideTime = picked);
                  },
                  child: Text(_overrideTime.format(context))))
      ]));
  Future<void> _pickTime(int index) async {
    final picked =
        await showTimePicker(context: context, initialTime: _times[index]);
    if (picked != null) setState(() => _times = [..._times]..[index] = picked);
  }

  static String _weekdayLabel(int day) =>
      const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][day - 1];
  static String _label(RoutineCategory value) => switch (value) {
        RoutineCategory.skincare => 'Skincare',
        RoutineCategory.medication => 'Medication',
        RoutineCategory.hydration => 'Hydration',
        RoutineCategory.wellness => 'Wellness',
        RoutineCategory.household => 'Household',
        RoutineCategory.custom => 'Other'
      };
}
