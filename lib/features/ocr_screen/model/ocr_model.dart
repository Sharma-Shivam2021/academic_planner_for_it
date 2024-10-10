import 'package:academic_planner_for_it/utilities/constants/constants.dart';

class OCRData {
  int id;
  String eventName;
  DateTime dateTime;
  int eventNotificationState;

  OCRData({
    this.id = -1,
    required this.eventName,
    required this.dateTime,
    this.eventNotificationState = EventNotificationState.created,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OCRData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          eventName == other.eventName &&
          dateTime == other.dateTime &&
          eventNotificationState == other.eventNotificationState;

  @override
  int get hashCode =>
      id.hashCode ^
      eventName.hashCode ^
      dateTime.hashCode ^
      eventNotificationState.hashCode;

  @override
  String toString() {
    return 'OCRData{id: $id, eventName: $eventName, dateTime: $dateTime, eventNotificationState: $eventNotificationState}';
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'dateTime': dateTime.toIso8601String(),
      'eventNotificationState': eventNotificationState,
    };
  }

  factory OCRData.fromMap(Map<String, dynamic> map) {
    return OCRData(
      id: map['id'] as int,
      eventName: map['eventName'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      eventNotificationState: map['eventNotificationState'] as int,
    );
  }

  OCRData copyWith({
    int? id,
    String? eventName,
    DateTime? dateTime,
    int? eventNotificationState,
    int? source,
  }) {
    return OCRData(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      dateTime: dateTime ?? this.dateTime,
      eventNotificationState:
          eventNotificationState ?? this.eventNotificationState,
    );
  }
}
