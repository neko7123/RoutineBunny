import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStore extends ChangeNotifier {
  PreferencesStore(this._preferences);

  final SharedPreferences _preferences;

  static const _onboardingKey = 'onboarding_completed';
  static const _usernameKey = 'username';
  static const _termsVersionKey = 'accepted_terms_version';
  static const _termsAcceptedAtKey = 'accepted_terms_at';
  static const _languageKey = 'language';
  static const _themeKey = 'theme';
  static const _currencyKey = 'currency_code';
  static const _notificationsKey = 'notifications_enabled';
  static const _alarmKey = 'alarm_enabled';
  static const _reminderLeadKey = 'reminder_lead_minutes';
  static const _notesKey = 'routine_notes';

  bool get hasCompletedOnboarding =>
      _preferences.getBool(_onboardingKey) ?? false;
  String? get username => _preferences.getString(_usernameKey);
  String? get acceptedTermsVersion => _preferences.getString(_termsVersionKey);
  DateTime? get termsAcceptedAt {
    final value = _preferences.getString(_termsAcceptedAtKey);
    return value == null ? null : DateTime.tryParse(value);
  }

  String get language {
    final value = _preferences.getString(_languageKey) ?? 'en';
    return switch (value) {
      'English' => 'en',
      'æ—¥æœ¬èªž' => 'ja',
      'ä¸­æ–‡' => 'zh',
      'í•œêµ­ì–´' => 'ko',
      _ => value,
    };
  }

  String get theme => _preferences.getString(_themeKey) ?? 'Pink (Default)';
  String get currencyCode => _preferences.getString(_currencyKey) ?? 'USD';
  bool get notificationsEnabled =>
      _preferences.getBool(_notificationsKey) ?? true;
  bool get alarmEnabled => _preferences.getBool(_alarmKey) ?? false;
  int get reminderLeadMinutes => _preferences.getInt(_reminderLeadKey) ?? 10;
  Future<void> setLanguage(String value) async {
    await _preferences.setString(_languageKey, value);
    notifyListeners();
  }

  Future<void> setCurrencyCode(String value) async {
    await _preferences.setString(_currencyKey, value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _preferences.setBool(_notificationsKey, value);
    notifyListeners();
  }

  Future<void> setAlarmEnabled(bool value) async {
    await _preferences.setBool(_alarmKey, value);
    notifyListeners();
  }

  Future<void> setReminderLeadMinutes(int value) async {
    await _preferences.setInt(_reminderLeadKey, value);
    notifyListeners();
  }

  Future<void> setTheme(String value) async {
    await _preferences.setString(_themeKey, value);
    notifyListeners();
  }

  Future<void> setUsername(String value) async {
    await _preferences.setString(_usernameKey, value);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _preferences.clear();
    notifyListeners();
  }

  String? noteFor(String id) => _preferences
      .getStringList(_notesKey)
      ?.where((value) => value.startsWith('$id\u001f'))
      .map((value) => value.substring(id.length + 1))
      .firstOrNull;
  Future<void> setNote(String id, String note) async {
    final values = [...?_preferences.getStringList(_notesKey)];
    values.removeWhere((value) => value.startsWith('$id\u001f'));
    values.add('$id\u001f$note');
    await _preferences.setStringList(_notesKey, values);
    notifyListeners();
  }

  Future<void> completeOnboarding({required String username}) async {
    await _preferences.setString(_usernameKey, username);
    await _preferences.setString(_termsVersionKey, '2026-01');
    await _preferences.setString(
        _termsAcceptedAtKey, DateTime.now().toUtc().toIso8601String());
    await _preferences.setBool(_onboardingKey, true);
    notifyListeners();
  }
}
