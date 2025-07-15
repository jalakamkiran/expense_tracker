import 'package:expense_tracker_clean/core/res/res.dart';

enum TransactionCategory {
  shopping('Shopping', Res.shopping),
  food('Food', Res.food),
  subscription('Subscription', Res.subscription);

  final String label;
  final String iconPath;

  const TransactionCategory(this.label, this.iconPath);
}


