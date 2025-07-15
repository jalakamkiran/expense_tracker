import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RepeatToggleRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RepeatToggleRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Repeat',
                style: AppTextStyles.body1.copyWith(color: AppColors.baseDark25),
              ),
              SizedBox(height: 4.h),
              Text(
                'Repeat transaction',
                style: AppTextStyles.small.copyWith(color: AppColors.baseLight20),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.violet100,
            activeTrackColor: AppColors.violet20,
            inactiveTrackColor: AppColors.violet20,
            inactiveThumbColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),

        ],
      ),
    );
  }
}
