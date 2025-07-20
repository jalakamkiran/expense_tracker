import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:expense_tracker_clean/core/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomeExpenseCards extends StatelessWidget {
  final double income;
  final double expense;

  const IncomeExpenseCards({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _card('Income', income, AppColors.green100, Res.income),
          SizedBox(width: 12.w),
          _card('Expenses', expense, AppColors.red100, Res.expense),
        ],
      ),
    );
  }

  Widget _card(String label, double amount, Color bgColor, String icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              SvgPicture.asset(icon),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.body3
                        .copyWith(color: AppColors.baseLight80),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    AppFunctions().formatRupees(amount),
                    style: AppTextStyles.label2
                        .copyWith(color: AppColors.baseLight80),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
