import 'package:intl/intl.dart';

/// Formats a [DateTime] object into a human-readable date and time string.///
/// The format is "Month Day, Year, Hour:Minute AM/PM".
///
/// Parameters:
///   - [dateTime]: The [DateTime] object to format.
///
/// Returns:
///   A formatted [String] representing the date and time.
String dateFormatter(DateTime dateTime) {
  return "${DateFormat.yMMMMd().format(dateTime)}, ${DateFormat.jmv().format(dateTime)}";
}

/// Formats a [DateTime] object into a date string.
///
/// The format is "Day Month Year".
///
/// Parameters:
///   - [dateTime]: The [DateTime] object to format.
///
/// Returns:
///   A formatted [String] representing the date.
String returnDate(DateTime dateTime) {
  return DateFormat.d().add_MMM().add_y().format(dateTime);
}

/// Formats a [DateTime] object into a time string.
///
/// The format is "Hour:Minute AM/PM".
///
/// Parameters:
///   - [dateTime]: The [DateTime] object to format.
///
/// Returns:
///   A formatted [String] representing the time.
String returnTime(DateTime dateTime) {
  return DateFormat.jmv().format(dateTime);
}
