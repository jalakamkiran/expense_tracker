import 'package:expense_tracker_clean/core/enums/transaction_category.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:expense_tracker_clean/core/utils/app_functions.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionType = TransactionType.values.firstWhere(
      (type) => type.label == transaction.type,
      orElse: () => TransactionType.expense,
    );

    final category = TransactionCategory.values.firstWhere(
      (cat) => cat.label == transaction.category,
      orElse: () => TransactionCategory.shopping,
    );

    final dateFormat = DateFormat('hh:mm a');
    final formattedTime = dateFormat.format(transaction.date);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.baseLight80,
        borderRadius: BorderRadius.circular(24.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Category Icon
          SvgPicture.asset(
            category.iconPath,
          ),

          SizedBox(width: 16.w),

          // Title and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.baseDark50,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.description ?? '',
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.baseLight20,
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Amount and Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transactionType == TransactionType.expense ? '-' : transactionType == TransactionType.income ? '+' : ''} ${AppFunctions().formatRupees(transaction.amount)}',
                style: AppTextStyles.body3.copyWith(
                  color: transactionType.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                formattedTime,
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.baseLight20,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
