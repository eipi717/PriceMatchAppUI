import 'dart:ffi';

import 'package:flutter/material.dart';

class SettingsConstants {
  // Section Titles
  static const String appPreferences = 'App Preferences';
  static const String accountSettings = 'Account Settings';
  static const String appSupport = 'Support';

  // Setting Options
  static const String enableNotifications = 'Enable Notifications';
  static const String selectTheme = 'Theme';
  static const String themeSubtitle = 'Select app theme';

  // Icons
  static const IconData notificationsIcon = Icons.notifications;
  static const IconData themeIcon = Icons.color_lens;

  // Sorting Options
  static const String sortByNameASC = 'Sort by Name (A-Z)';
  static const String sortByNameDESC = 'Sort by Name (Z-A)';
  static const String sortByCategoryASC = 'Sort by Category (A-Z)';
  static const String sortByCategoryDESC = 'Sort by Category (Z-A)';

  // Dropdown Options
  static const String allCategory = 'All Categories';

  // Search Bar
  static const String searchBarInnerText = 'Search products...';

}