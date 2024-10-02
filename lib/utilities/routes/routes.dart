import 'package:academic_planner_for_it/features/home_screen/views/home_screen.dart';
import 'package:academic_planner_for_it/features/ocr_screen/views/ocr_screen.dart';
import 'package:academic_planner_for_it/features/settings_screen/views/settings_screen.dart';
import '../../features/import_excel/views/import_excel.dart';
import '../../features/splash_screen/views/splash_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ImportExcelScreen.routeName: (context) => const ImportExcelScreen(),
  OcrScreen.routeName: (context) => const OcrScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
};
