import 'package:academic_planner_for_it/features/home_screen/views/home_screen.dart';
import 'package:academic_planner_for_it/features/settings_screen/views/settings_screen.dart';
import '../../features/import_excel/views/import_excel.dart';
import '../../features/splash_screen/views/splash_screen.dart';
import 'package:flutter/material.dart';

/// Defines the navigation routes for the application.
///
/// This map associates route names (strings) with the corresponding widget
/// builders. Each route name is a static constant defined in the respective
/// screen's class.
Map<String, Widget Function(BuildContext)> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ImportExcelScreen.routeName: (context) => const ImportExcelScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
};
