import 'package:flutter/material.dart';
import 'package:price_match_app_ui/common/constants/style_constants.dart';
import 'package:price_match_app_ui/common/widgets/section_heading.dart';
import 'package:price_match_app_ui/pages/setting_page/widgets/account_settings/account_settings.dart';
import 'package:price_match_app_ui/pages/setting_page/widgets/app_preferences/app_preferences.dart';
import 'package:price_match_app_ui/pages/setting_page/widgets/app_support/support.dart';
import 'package:price_match_app_ui/pages/setting_page/widgets/logout.dart';
import 'package:price_match_app_ui/common/constants/setting_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/enum.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  ThemeModeOption themeMode = ThemeModeOption.system;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load settings from persistent storage
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      int themeIndex = prefs.getInt('themeMode') ?? ThemeModeOption.system.index;
      themeMode = ThemeModeOption.values[themeIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Account Settings Section
          const SectionHeading(SettingsConstants.accountSettings, StyleConstants.sectionHeaderPadding),
          AccountSettings(),
          const Divider(),
          // App Preferences Section
          const SectionHeading(SettingsConstants.appPreferences, StyleConstants.sectionHeaderPadding),
          const AppPreferences(),
          const Divider(),
          // Support Section
          const SectionHeading(SettingsConstants.appSupport, StyleConstants.sectionHeaderPadding),
          const AppSupport(),
          const Divider(),
          // Logout Section
          Logout()
        ],
      ),
    );
  }
}

