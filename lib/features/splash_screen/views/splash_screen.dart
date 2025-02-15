import 'package:academic_planner_for_it/features/home_screen/views/home_screen.dart';
import 'package:academic_planner_for_it/utilities/services/notification_services.dart';
import 'package:academic_planner_for_it/utilities/services/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utilities/services/database.dart';

/// The splash screen widget for the application.
///
/// This screen is displayed when the app is first launched. It initializes
/// essential services such as notifications, text-to-speech (TTS), and the
/// database, and then navigates to the [HomeScreen].
class SplashScreen extends ConsumerStatefulWidget {
  static const String routeName = '/splashScreen';

  /// Creates a [SplashScreen].
  ///
  /// Parameters:
  ///- [key]: An optional key to identify this widget.
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeNotificationsAndTtsAndDBAndSharedPreference();
  }

  /// Initializes the notification, TTS, database, and shared preferences services.
  ///
  /// This method initializes the [NotificationServices], [TTSService], and
  /// the database. After initialization, it navigates to the [HomeScreen].
  ///
  /// Throws an exception if any of the initialization steps fail.
  Future<void> _initializeNotificationsAndTtsAndDBAndSharedPreference() async {
    try {
      await NotificationServices().initialize();
      await TTSService().initializeTTS();
      await ref.read(databaseProvider);
      if (mounted) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/appicon.png',
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            const SizedBox(height: 20),
            const Text(
              'Academic Planner',
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 24,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 50),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
