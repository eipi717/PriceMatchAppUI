import 'package:intl/intl.dart';

class DatetimeUtils {
  static DateTime tsToDateTime(int ts) {
    return DateTime.fromMillisecondsSinceEpoch(ts);
  }

  static String formatDateMMDD(DateTime date) {
    final DateFormat formatter = DateFormat('MM/dd');
    return formatter.format(date);
  }
}