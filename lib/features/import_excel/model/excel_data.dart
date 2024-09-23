import '../../../utilities/constants/constants.dart';

class ExcelData {
  int id;
  String eventName;
  DateTime dateTime;
  int eventNotificationState;
  int source;

  ExcelData({
    this.id = -1,
    required this.eventName,
    required this.dateTime,
    this.eventNotificationState = EventNotificationState.created,
    this.source = DataSource.excel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExcelData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          eventName == other.eventName &&
          dateTime == other.dateTime &&
          eventNotificationState == other.eventNotificationState &&
          source == other.source);

  @override
  int get hashCode =>
      id.hashCode ^
      eventName.hashCode ^
      dateTime.hashCode ^
      eventNotificationState.hashCode ^
      source.hashCode;

  @override
  String toString() {
    return 'ExcelData{ id: $id, eventName: $eventName, dateTime: $dateTime, eventNotificationState: $eventNotificationState, source: $source,}';
  }

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
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'dateTime': dateTime.toIso8601String(),
      'eventNotificationState': eventNotificationState,
      'source': source,
    };
  }

  factory ExcelData.fromMap(Map<String, dynamic> map) {
    return ExcelData(
      id: map['id'] as int,
      eventName: map['eventName'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      eventNotificationState: map['eventNotificationState'] as int,
      source: map['source'] as int,
    );
  }
}
