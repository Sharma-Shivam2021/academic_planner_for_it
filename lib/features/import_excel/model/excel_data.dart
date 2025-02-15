import '../../../utilities/constants/constants.dart';

/// Represents data imported from an Excel file or stored in the database.
///
///This class encapsulates the data for a single event, including its name,
/// date and time, and notification state.
class ExcelData {
  int id;
  String eventName;
  DateTime dateTime;
  int eventNotificationState;

  /// Creates an [ExcelData] instance.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier for the event. Defaults to -1.
  ///   - [eventName]: The name of the event.
  ///   - [dateTime]: The date and time of the event.///   - [eventNotificationState]: The notification state of the event.
  ///     Defaults to [EventNotificationState.created].
  ExcelData({
    this.id = -1,
    required this.eventName,
    required this.dateTime,
    this.eventNotificationState = EventNotificationState.created,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExcelData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          eventName == other.eventName &&
          dateTime == other.dateTime &&
          eventNotificationState == other.eventNotificationState);

  @override
  int get hashCode =>
      id.hashCode ^
      eventName.hashCode ^
      dateTime.hashCode ^
      eventNotificationState.hashCode;

  @override
  String toString() {
    return 'ExcelData{ id: $id, eventName: $eventName, dateTime: $dateTime, eventNotificationState: $eventNotificationState}';
  }

  /// Creates a copy of this [ExcelData] instance with the given fields
  /// replaced by the new values.
  ///
  /// Parameters:
  ///   - [id]: The new id for the copy.
  ///   - [eventName]: The new event name for the copy.
  ///   - [dateTime]: The new date and time for the copy.
  ///   - [eventNotificationState]: The new notification state for the copy.
  ///
  /// Returns:
  ///   A new [ExcelData] instance with the specified fields updated.
  ExcelData copyWith({
    int? id,
    String? eventName,
    DateTime? dateTime,
    int? eventNotificationState,
    int? source,
  }) {
    return ExcelData(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      dateTime: dateTime ?? this.dateTime,
      eventNotificationState:
          eventNotificationState ?? this.eventNotificationState,
    );
  }

  /// Converts this [ExcelData] instance to a map.
  ///
  /// This method is used for saving the data to a database or other
  /// persistent storage.
  ///
  /// Returns:
  ///   A [Map] representing the data.
  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'dateTime': dateTime.toIso8601String(),
      'eventNotificationState': eventNotificationState,
    };
  }

  /// Creates an [ExcelData] instance from a map.
  ///
  /// This method is used for loading the data from a database or other
  /// persistent storage.
  ///
  /// Parameters:
  ///   - [map]: A [Map] representing the data.
  ///
  /// Returns:
  ///   An [ExcelData] instance.
  factory ExcelData.fromMap(Map<String, dynamic> map) {
    return ExcelData(
      id: map['id'] as int,
      eventName: map['eventName'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      eventNotificationState: map['eventNotificationState'] as int,
    );
  }
}
