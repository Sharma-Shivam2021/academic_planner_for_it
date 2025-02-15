/// The earliest date allowed for event selection.
DateTime kFirstDate = DateTime(2000);

/// The latest date allowed for event selection.
DateTime kLastDate = DateTime(2400);

/// The initial date used for date pickers, set to the current date and time.
DateTime kInitialDate = DateTime.now();

/// The name of the events table in the database.
String kEventsTable = 'events';

/// A SQL query to count the number of rows in the events table.
String kTableCount = 'SELECT COUNT(*) FROM $kEventsTable';

/// Defines the possible states of an event's notification.
class EventNotificationState {
  /// Indicates that the event has been created but not yet notified.
  static const created = 0;

  /// Indicates that the event has been notified.
  static const notified = 1;

  /// Indicates that the event has been spoken (TTS).
  static const spoken = 2;
}
