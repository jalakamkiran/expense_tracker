import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:expense_tracker_clean/core/utils/app_functions.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionDetailHeader extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onDelete;

  const TransactionDetailHeader({
    super.key,
    required this.transaction,
    this.onDelete,
  });

  TransactionType get _transactionType {
    switch (transaction.type.toLowerCase()) {
      case 'income':
        return TransactionType.income;
      case 'transfer':
        return TransactionType.transfer;
      case 'expense':
      default:
        return TransactionType.expense;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        left: 16.w,
        right: 16.w,
        bottom: 40.h,
      ),
      decoration: BoxDecoration(
        color: _transactionType.color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          // App bar
          _buildAppBar(context),
          SizedBox(height: 40.h),
          // Amount
          Text(
            '₹${transaction.amount.toInt()}',
            style: TextStyle(
              fontSize: 64.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          // Date and time
          Text(
            AppFunctions().formatDateTime(transaction.date),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            Res.arrowLeft,
            width: 24.w,
            height: 24.h,
            color: Colors.white,
          ),
        ),
        Text(
          'Detail Transaction',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: onDelete,
          child: SvgPicture.asset(
            Res.trash,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
