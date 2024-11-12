import 'package:flutter/material.dart';
import 'package:price_match_app_ui/pages/home_page/home_page.dart';
import 'package:price_match_app_ui/utils/theme_utils.dart';
import 'package:provider/provider.dart';
import '../common/states/auth_notifier.dart';
import '../common/states/setting_notifier.dart';
import 'auth/login_page/login_page.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthNotifier>(
                create: (_) => AuthNotifier(),
            ),
            ChangeNotifierProvider<SettingsNotifier>(
                create: (_) => SettingsNotifier(),
            )
          ],
          child: PriceMatchApp()
      )
  );
}

class PriceMatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthNotifier, SettingsNotifier>(
        builder: (context, authNotifier, settingsNotifier, child) {
          return MaterialApp(
            title: 'Price Match App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsNotifier.themeMode,
              home: authNotifier.isAuthenticated ? HomePage() : LoginPage(),
          );
        }
    );
  }
}