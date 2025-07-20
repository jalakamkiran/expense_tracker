import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionDescriptionSection extends StatelessWidget {
  final String? description;

  const TransactionDescriptionSection({
    super.key,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyles.body1.copyWith(color: AppColors.baseDark100),
        ),
        SizedBox(height: 12.h),
        Text(
          description ?? '',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}