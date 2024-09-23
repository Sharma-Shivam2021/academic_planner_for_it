//Project Packages
import 'package:academic_planner_for_it/utilities/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Project Classes
import 'features/splash_screen/views/splash_screen.dart';
import 'utilities/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightMode,
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
