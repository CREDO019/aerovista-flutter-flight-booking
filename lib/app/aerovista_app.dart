import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import 'app_routes.dart';

/// Root widget for the AeroVista app.
/// Configures MaterialApp with dark theme, routes, and no debug banner.
class AeroVistaApp extends StatelessWidget {
  const AeroVistaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
