import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  final String imageAssetPath;
  final VoidCallback? onClose;

  const SuccessDialog({
    super.key,
    required this.message,
    required this.imageAssetPath,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              imageAssetPath,
              height: 100.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body3.copyWith(color: AppColors.baseDark100),
            ),
          ],
        ),
      ),
    );
  }
}
