import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

enum TransactionType {
  expense('Expense', Color(0xFFEB5757),""),
  income('Income', Color(0xFF27AE60),""),
  transfer('Transfer', Color(0xFF2D9CDB),"");

  final String label;
  final Color color;
  final String icon;

  const TransactionType(this.label, this.color,this.icon);
}

