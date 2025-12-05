import 'package:intl/intl.dart';

class DateHelpers {
  /// Returns:
  /// - "Today"
  /// - "Tomorrow"
  /// - "Yesterday"
  /// - OR formatted day name
  static String friendlyDayText(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return "Today";

    if (d == today.add(const Duration(days: 1))) return "Tomorrow";

    if (d == today.subtract(const Duration(days: 1))) return "Yesterday";

    return DateFormat.EEEE().format(d); // Monday, Tuesday, ...
  }
}
