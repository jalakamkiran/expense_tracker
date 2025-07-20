import 'package:intl/intl.dart';

class AppFunctions {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String formatDateTime(DateTime dateTime) {
    String weekday = weekdays[dateTime.weekday - 1];
    String month = months[dateTime.month - 1];
    String day = dateTime.day.toString();
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return '$weekday $day $month $year  $hour:$minute';
  }

  int computeMonthIndex(String? month) {
    if (month == null) return DateTime.now().month;
    return months.indexOf(month) + 1;
  }

  String formatRupees(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN', // Indian locale
      symbol: '₹',
      decimalDigits: amount.truncateToDouble() == amount ? 0 : 2,
    );

    return formatter.format(amount);
  }
}
