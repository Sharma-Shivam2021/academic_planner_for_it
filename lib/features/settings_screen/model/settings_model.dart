class Settings {
  final Duration configTimeForSubtract;

  Settings({required this.configTimeForSubtract});

  // Convert to a map for saving
  Map<String, dynamic> toJson() {
    return {
      'configTimeForSubtract': configTimeForSubtract.inHours,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      configTimeForSubtract:
          Duration(hours: json['configTimeForSubtract'] ?? 24),
    );
  }
}
