import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/setting_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  static const String routeName = '/settingScreen';
  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.watch(settingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 20),
            const Text('Config Time for Subtract (hours):'),
            Slider(
              value: settings.configTimeForSubtract.inHours.toDouble(),
              min: 1,
              max: 72,
              divisions: 3,
              label: settings.configTimeForSubtract.inHours.toString(),
              onChanged: (value) {
                settingsNotifier.updateConfigTimeForSubtract(
                    Duration(hours: value.toInt()));
              },
            ),
            const SizedBox(height: 20),
            Text('Selected Hours: ${settings.configTimeForSubtract.inHours}'),
            const Text(
              'This is the amount of time that the automated system subtracts from the provided time to remind you earlier of the events time.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
