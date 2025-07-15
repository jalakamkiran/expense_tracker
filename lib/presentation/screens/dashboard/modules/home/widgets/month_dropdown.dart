import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MonthDropdown extends StatelessWidget {
  final String? selectedMonth;
  final ValueChanged<String?> onChanged;

  const MonthDropdown({
    Key? key,
    required this.selectedMonth,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> months = [
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
      'December',
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: AppColors.baseLight60,
          width: 2.w,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMonth,
          isDense: true,
          icon: const SizedBox.shrink(),
          hint: Row(
            children: [
              SizedBox(width: 8.w),
              SvgPicture.asset(
                Res.arrowDown,
                color: AppColors.violet100,
                height: 24.h,
                width: 24.w,
              ),
              SizedBox(width: 4.w),
              Text(
                selectedMonth ?? months[DateTime.now().month - 1],
                style: AppTextStyles.body3.copyWith(color: AppColors.baseDark50),
              ),
            ],
          ),
          items: months.map((String month) {
            return DropdownMenuItem<String>(
              value: month,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 8.w),
                  SvgPicture.asset(
                    Res.arrowDown,
                    color: AppColors.violet100,
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    month,
                    style: AppTextStyles.body3.copyWith(color: AppColors.baseDark50),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: false,
          dropdownColor: const Color(0xFFF5F3F0),
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
    );
  }
}
