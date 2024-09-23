import 'package:intl/intl.dart';

String dateFormatter(DateTime dateTime) {
  return "${DateFormat.yMMMMd().format(dateTime)}, ${DateFormat.jmv().format(dateTime)}";
}

String returnDate(DateTime dateTime) {
  return DateFormat.d().add_MMM().add_y().format(dateTime);
}

String returnTime(DateTime dateTime) {
  return DateFormat.jmv().format(dateTime);
}
