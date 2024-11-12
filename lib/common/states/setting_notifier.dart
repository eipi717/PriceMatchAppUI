import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enum.dart';


class SettingsNotifier with ChangeNotifier {
  // Theme
  ThemeMode _themeMode = ThemeMode.system;
  ThemeModeOption _themeModeOption = ThemeModeOption.system;

  // Notifications
  bool _notificationsEnabled = true;

  SettingsNotifier() {
    _loadSettings();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  ThemeModeOption get themeModeOption => _themeModeOption;
  bool get notificationsEnabled => _notificationsEnabled;

  // Setters
  Future<void> setTheme(ThemeModeOption option) async {
    _themeModeOption = option;
    switch (option) {
      case ThemeModeOption.light:
        _themeMode = ThemeMode.light;
        break;
      case ThemeModeOption.dark:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeModeOption.system:
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
    await _saveTheme(option);
  }

  Future<void> toggleNotifications(bool isEnabled) async {
    _notificationsEnabled = isEnabled;
    notifyListeners();
    await _saveNotifications(isEnabled);
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load Theme
    int? themeIndex = prefs.getInt('themeModeOption');
    if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeModeOption.values.length) {
      setTheme(ThemeModeOption.values[themeIndex]);
    }

    // Load Notifications
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    notifyListeners();
  }

  // Save Theme to SharedPreferences
  Future<void> _saveTheme(ThemeModeOption option) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeModeOption', option.index);
  }

  // Save Notifications to SharedPreferences
  Future<void> _saveNotifications(bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', isEnabled);
  }
}