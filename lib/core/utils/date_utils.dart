import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormat).format(date);
  }

  /// Formats date with "Today" and "Yesterday" for recent dates
  static String formatDateTimeWithRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    // Format time as "hh:mm a" (e.g., "10:30 AM")
    final timeFormat = DateFormat('hh:mm a');
    final timeString = timeFormat.format(date);

    if (dateOnly == today) {
      return 'Today $timeString';
    } else if (dateOnly == yesterday) {
      return 'Yesterday $timeString';
    } else {
      return formatDateTime(date);
    }
  }

  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat(AppConstants.dateFormat).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  static DateTime getStartOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  static DateTime getStartOfLast7Days() {
    return DateTime.now().subtract(const Duration(days: 7));
  }

  static DateTime getStartOfLast30Days() {
    return DateTime.now().subtract(const Duration(days: 30));
  }

  static DateTime getStartOfYear() {
    final now = DateTime.now();
    return DateTime(now.year, 1, 1);
  }

  static bool isWithinRange(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start.subtract(const Duration(days: 1))) &&
        date.isBefore(end.add(const Duration(days: 1)));
  }
}
