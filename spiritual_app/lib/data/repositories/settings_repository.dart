import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/settings_state.dart';

class SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  static const String _themeModeKey = 'settings_theme_mode';
  static const String _appColorKey = 'settings_app_color';
  static const String _notificationsEnabledKey = 'settings_notifications_enabled';

  Future<void> saveSettings(SettingsState state) async {
    await _prefs.setString(_themeModeKey, state.themeMode.name);
    await _prefs.setInt(_appColorKey, state.appColor.toARGB32());
    await _prefs.setBool(_notificationsEnabledKey, state.notificationsEnabled);
  }

  SettingsState loadSettings({required Color defaultColor}) {
    final themeModeString = _prefs.getString(_themeModeKey);
    final themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == themeModeString,
      orElse: () => ThemeMode.system,
    );

    final colorInt = _prefs.getInt(_appColorKey);
    final appColor = colorInt != null ? Color(colorInt) : defaultColor;

    final notificationsEnabled = _prefs.getBool(_notificationsEnabledKey) ?? true;

    return SettingsState(
      themeMode: themeMode,
      appColor: appColor,
      notificationsEnabled: notificationsEnabled,
    );
  }
}
