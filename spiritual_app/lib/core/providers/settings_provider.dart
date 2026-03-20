import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/settings_state.dart';
import '../../data/repositories/settings_repository.dart';
import '../theme/app_colors.dart';

// Provider for SharedPreferences instance. Must be overridden in ProviderScope.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

// Provider for SettingsRepository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs);
});

// Settings Notifier
class SettingsNotifier extends Notifier<SettingsState> {
  late SettingsRepository _repository;

  @override
  SettingsState build() {
    _repository = ref.watch(settingsRepositoryProvider);
    // Initial color is templeRed
    return _repository.loadSettings(defaultColor: AppColors.templeRed);
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final newState = state.copyWith(themeMode: mode);
    state = newState;
    await _repository.saveSettings(newState);
  }

  Future<void> updateAppColor(Color color) async {
    final newState = state.copyWith(appColor: color);
    state = newState;
    await _repository.saveSettings(newState);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final newState = state.copyWith(notificationsEnabled: enabled);
    state = newState;
    await _repository.saveSettings(newState);
  }
}

// Provider for SettingsNotifier
final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
