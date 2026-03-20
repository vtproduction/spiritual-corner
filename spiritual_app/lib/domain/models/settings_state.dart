import 'package:flutter/material.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Color appColor;
  final bool notificationsEnabled;

  const SettingsState({
    required this.themeMode,
    required this.appColor,
    required this.notificationsEnabled,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Color? appColor,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      appColor: appColor ?? this.appColor,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
