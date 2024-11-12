import 'package:flutter/material.dart';
import 'package:price_match_app_ui/utils/string_utils.dart';
import 'package:provider/provider.dart';
import '../../../../common/enum.dart';
import '../../../../common/states/setting_notifier.dart';
import '../../../../common/constants/setting_constants.dart';

class AppPreferences extends StatelessWidget {
  const AppPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, settingsNotifier, child) {
        return Column(
          children: [
            // Notifications Toggle
            SwitchListTile(
              secondary: Icon(
                SettingsConstants.notificationsIcon,
                color: Colors.blue.shade800,
              ),
              title: const Text(SettingsConstants.enableNotifications),
              value: settingsNotifier.notificationsEnabled,
              onChanged: (bool value) {
                settingsNotifier.toggleNotifications(value);
              },
            ),
            // Theme Selection
            ListTile(
              leading: Icon(
                SettingsConstants.themeIcon,
                color: Colors.blue.shade800,
              ),
              title: const Text(SettingsConstants.selectTheme),
              subtitle: const Text(SettingsConstants.themeSubtitle),
              trailing: DropdownButton<ThemeModeOption>(
                value: settingsNotifier.themeModeOption,
                onChanged: (ThemeModeOption? mode) {
                  if (mode != null) {
                    settingsNotifier.setTheme(mode);
                  }
                },
                items: ThemeModeOption.values.map((ThemeModeOption mode) {
                  return DropdownMenuItem<ThemeModeOption>(
                    value: mode,
                    child: Text(mode.toString().split('.').last.capitalize()),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}