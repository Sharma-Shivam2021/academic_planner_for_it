import 'package:academic_planner_for_it/features/home_screen/views/home_screen.dart';
import 'package:academic_planner_for_it/utilities/services/notification_services.dart';
import 'package:academic_planner_for_it/utilities/services/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utilities/services/database.dart';
import '../../home_screen/models/events.dart';
import '../../home_screen/view_models/event_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String routeName = '/splashScreen';
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
