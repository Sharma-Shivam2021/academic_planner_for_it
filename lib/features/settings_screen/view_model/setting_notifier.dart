import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/settings_model.dart';

/// Provides access to the application's settings.
///
/// This provider allows widgets to read and update the current settings.
final settingsProvider =
    StateNotifierProvider<SettingNotifier, Settings>((ref) {
  return SettingNotifier();
});

/// A [StateNotifier] that manages the application's settings.
///
/// This class handles loading, updating, and saving settings to shared preferences.
class SettingNotifier extends StateNotifier<Settings> {
  /// Creates a [SettingNotifier].
  ///
  /// Initializes the settings with default values and loads any saved settings
  /// from shared preferences.
  SettingNotifier()
      : super(
          Settings(
            configTimeForSubtract: const Duration(hours: 24),
          ),
        ) {
    _loadSettings();
  }

  /// Loads settings from shared preferences.
  ///
  /// This method retrieves the saved settings from shared preferences and
  /// updates the state accordingly. If no settings are found, it uses default values.
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final configTimeForSubtractHours =
        prefs.getInt('configTimeForSubtract') ?? 24;

    state = Settings(
      configTimeForSubtract: Duration(hours: configTimeForSubtractHours),
    );
  }

  /// Updates the configuration time for subtracting from event times.
  ///
  /// This method updates the `configTimeForSubtract` setting and saves the
  /// changes to shared preferences.
  ///
  /// Parameters:
  ///   - [duration]: The new duration to use for subtracting from event times.
  Future<void> updateConfigTimeForSubtract(Duration duration) async {
    state = Settings(
      configTimeForSubtract: duration,
    );
    await _saveSettings();
  }

  /// Saves the current settings to shared preferences.
  ///
  /// This method persists the current settings to shared preferences so they
  /// can be loaded on the next app launch.
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'configTimeForSubtract',
      state.configTimeForSubtract.inHours,
    );
  }
}
