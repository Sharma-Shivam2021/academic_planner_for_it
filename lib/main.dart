/// This is the main entry point for the Academic Planner
///
/// It initializes the Flutter framework, sets up the application's theme,
/// and configures the initial route and navigation
library;

import 'package:academic_planner_for_it/utilities/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

//Project Classes
import 'features/splash_screen/views/splash_screen.dart';
import 'utilities/routes/routes.dart';

/// Main Function of the Application.
///
/// This function is the first to be executed when the app starts.
/// It initializes the Flutter framework, enables fallback for file downloads,
/// sets the preferred device orientation to portrait up, and runs the app.
void main() {
  // Ensures that the Flutter framework is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Sets the preferred device orientation to portrait up.
  Share.downloadFallbackEnabled = true;
  // Sets the preferred device orientation to portrait up.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Runs the app within a ProviderScope for state management.
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

///The root widget of the application.
///
/// This widget configures the MaterialApp with app's theme, initial route,
/// and navigation routes
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Sets the light theme for the app.
      theme: AppTheme.lightMode,
      // Sets the dark theme for the app.
      darkTheme: AppTheme.darkMode,
      // Sets the initial route to the splash screen.
      initialRoute: SplashScreen.routeName,
      // Defines the navigation routes for the app.
      routes: routes,
    );
  }
}
