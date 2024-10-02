import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/settings_model.dart';

final settingsProvider =
    StateNotifierProvider<SettingNotifier, Settings>((ref) {
  return SettingNotifier();
});

class SettingNotifier extends StateNotifier<Settings> {
  SettingNotifier()
      : super(
          Settings(
            configTimeForSubtract: const Duration(hours: 24),
          ),
        ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final configTimeForSubtractHours =
        prefs.getInt('configTimeForSubtract') ?? 24;

    state = Settings(
      configTimeForSubtract: Duration(hours: configTimeForSubtractHours),
    );
  }

  Future<void> updateConfigTimeForSubtract(Duration duration) async {
    state = Settings(
      configTimeForSubtract: duration,
    );
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'configTimeForSubtract',
      state.configTimeForSubtract.inHours,
    );
  }
}
