DateTime kFirstDate = DateTime(2000);
DateTime kLastDate = DateTime(2400);
DateTime kInitialDate = DateTime.now();

String kEventsTable = 'events';
String kNotificationSound = 'new_event_female';

class EventNotificationState {
  static const created = 0;
  static const notified = 1;
  static const spoken = 2;
}

class DataSource {
  static const manual = 0;
  static const excel = 1;
  static const ocr = 2;
}

Duration kConfigTimeForSubtract = const Duration(hours: 24);
