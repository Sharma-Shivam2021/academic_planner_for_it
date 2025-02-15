/// Represents the application's settings.
///
/// This class holds the configuration for various settings, such as the time
/// to subtract from events for reminders.
class Settings {
  /// The duration to subtract from event times for reminders.
  final Duration configTimeForSubtract;

  /// Creates a [Settings] instance.
  ///
  /// Parameters:
  ///   - [configTimeForSubtract]: The duration to subtract from event times for reminders.
  Settings({required this.configTimeForSubtract});

  /// Converts the [Settings] instance to a map.
  ///
  /// This method is used for saving the settings to persistent storage.
  ///
  /// Returns:
  ///   A [Map] representing the settings.
  Map<String, dynamic> toJson() {
    return {
      'configTimeForSubtract': configTimeForSubtract.inHours,
    };
  }

  /// Creates a [Settings] instance from a map.
  ///
  /// This method is used for loading the settings from persistent storage.
  ///
  /// Parameters:
  ///   - [json]: A [Map] representing the settings.
  ///
  /// Returns:
  ///   A [Settings] instance.
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      configTimeForSubtract:
          Duration(hours: json['configTimeForSubtract'] ?? 24),
    );
  }
}
