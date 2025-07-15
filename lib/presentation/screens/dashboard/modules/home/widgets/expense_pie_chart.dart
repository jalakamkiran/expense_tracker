import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpensePieChart extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  const ExpensePieChart({
    Key? key,
    required this.totalIncome,
    required this.totalExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = totalIncome + totalExpense;

    if (total == 0) return const SizedBox.shrink();

    final expensePercent = (totalExpense / total * 100).toStringAsFixed(1);
    final incomePercent = (totalIncome / total * 100).toStringAsFixed(1);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expense Distribution',
            style: AppTextStyles.title3.copyWith(
              color: AppColors.baseDark100,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: totalExpense,
                    color: AppColors.red100,
                    radius: 50.r,
                    title: '',
                  ),
                  PieChartSectionData(
                    value: totalIncome,
                    color: AppColors.green100,
                    radius: 50.r,
                    title: '',
                  ),
                ],
                sectionsSpace: 4,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(
                  color: AppColors.red100, label: 'Expenses', percent: expensePercent),
              _buildLegendItem(
                  color: AppColors.green100, label: 'Income', percent: incomePercent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String percent,
  }) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '$label • $percent%',
          style: AppTextStyles.body3.copyWith(
            color: AppColors.baseDark50,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
