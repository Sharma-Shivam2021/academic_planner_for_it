DateTime kFirstDate = DateTime(2000);
DateTime kLastDate = DateTime(2400);
DateTime kInitialDate = DateTime.now();

String kEventsTable = 'events';

class EventNotificationState {
  static const created = 0;
  static const notified = 1;
  static const spoken = 2;
}
