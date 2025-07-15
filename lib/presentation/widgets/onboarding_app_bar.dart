import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const OnBoardingAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: onBackPressed ?? () => Navigator.of(context).pop(),
            child: SvgPicture.asset(
              Res.arrowLeft,
              width: 24.w,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: AppTextStyles.title3.copyWith(color: AppColors.white),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}