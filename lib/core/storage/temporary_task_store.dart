import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemporaryTask {
  const TemporaryTask(
      {required this.id,
      required this.date,
      required this.name,
      required this.hour,
      required this.minute,
      this.completed = false});
  final String id;
  final DateTime date;
  final String name;
  final int hour;
  final int minute;
  final bool completed;

  TemporaryTask copyWith({bool? completed}) => TemporaryTask(
      id: id,
      date: date,
      name: name,
      hour: hour,
      minute: minute,
      completed: completed ?? this.completed);
  Map<String, Object?> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'name': name,
        'hour': hour,
        'minute': minute,
        'completed': completed
      };
  factory TemporaryTask.fromJson(Map<String, Object?> json) => TemporaryTask(
      id: '${json['id']}',
      date: DateTime.parse('${json['date']}'),
      name: '${json['name']}',
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      completed: json['completed'] as bool? ?? false);
}

class TemporaryTaskStore extends ChangeNotifier {
  TemporaryTaskStore(this._preferences) {
    final value = _preferences.getStringList(_key) ?? const [];
    _tasks = value
        .map((item) => TemporaryTask.fromJson(
            Map<String, Object?>.from(jsonDecode(item) as Map)))
        .toList();
  }

  static const _key = 'temporary_day_tasks';
  final SharedPreferences _preferences;
  List<TemporaryTask> _tasks = [];

  List<TemporaryTask> forDate(DateTime date) => List.unmodifiable(
      _tasks.where((task) => DateUtils.isSameDay(task.date, date)));
  List<Map<String, Object?>> exportData() =>
      _tasks.map((task) => task.toJson()).toList();
  Future<void> importData(List<dynamic> data) async {
    _tasks = data
        .map((value) =>
            TemporaryTask.fromJson(Map<String, Object?>.from(value as Map)))
        .toList();
    await _save();
    notifyListeners();
  }

  Future<void> add(
      {required DateTime date,
      required String name,
      required TimeOfDay time}) async {
    _tasks = [
      ..._tasks,
      TemporaryTask(
          id: 'temporary_${DateTime.now().microsecondsSinceEpoch}',
          date: DateUtils.dateOnly(date),
          name: name,
          hour: time.hour,
          minute: time.minute)
    ];
    await _save();
    notifyListeners();
  }

  Future<void> setCompleted(TemporaryTask task, bool completed) async {
    _tasks = _tasks
        .map((value) =>
            value.id == task.id ? value.copyWith(completed: completed) : value)
        .toList();
    await _save();
    notifyListeners();
  }

  Future<void> _save() => _preferences.setStringList(
      _key, _tasks.map((task) => jsonEncode(task.toJson())).toList());
}
