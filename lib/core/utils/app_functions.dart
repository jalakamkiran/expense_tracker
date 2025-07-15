import 'package:intl/intl.dart';

class AppFunctions {
  String formatRupees(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN', // Indian locale
      symbol: '₹',
      decimalDigits: amount.truncateToDouble() == amount ? 0 : 2,
    );

    return formatter.format(amount);
  }
}
