import '../../../utilities/constants/constants.dart';

/// Represents an event with a name, date/time, and notification state.
class Events {
  int id;
  String eventName;
  DateTime dateTime;
  int eventNotificationState;

  /// Creates an [Events] instance.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier of the event. Defaults to -1.
  ///   - [eventName]: The name of the event.
  ///   - [dateTime]: The date and time of the event.
  ///   - [eventNotificationState]: The notification state of the event.
  ///     Defaults to [EventNotificationState.created].
  Events({
    this.id = -1,
    required this.eventName,
    required this.dateTime,
    this.eventNotificationState = EventNotificationState.created,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Events &&
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
    return 'Events{ id: $id, eventName: $eventName, dateTime: $dateTime, eventNotificationState: $eventNotificationState}';
  }

  /// Creates a copy of this [Events] instance with the given fields replaced.
  ///
  /// Parameters:
  ///   - [id]: The new id.
  ///   - [eventName]: The new event name.
  ///   - [dateTime]: The new date and time.
  ///   - [eventNotificationState]: The new notification state.
  ///
  /// Returns a new [Events] instance with the specified fields updated.
  Events copyWith({
    int? id,
    String? eventName,
    DateTime? dateTime,
    int? eventNotificationState,
    int? source,
  }) {
    return Events(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      dateTime: dateTime ?? this.dateTime,
      eventNotificationState:
          eventNotificationState ?? this.eventNotificationState,
    );
  }

  /// Converts this [Events] instance to a map.
  ///
  /// Returns a [Map] representation of this [Events] instance.
  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'dateTime': dateTime.toIso8601String(),
      'eventNotificationState': eventNotificationState,
    };
  }

  /// Creates an [Events] instance from a map.
  ///
  /// Parameters:
  ///   - [map]: The map to create the [Events] instance from.
  ///
  /// Returns an [Events] instance created from the map.
  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
      id: map['id'] as int,
      eventName: map['eventName'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      eventNotificationState: map['eventNotificationState'] as int,
    );
  }
}
