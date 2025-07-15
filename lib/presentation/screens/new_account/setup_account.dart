import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/routes/routes.dart';
import 'package:expense_tracker_clean/presentation/widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetupAccountScreen extends StatelessWidget {
  const SetupAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              // Title
              Text(
                "Let's setup your\naccount!",
                style: AppTextStyles.heading2
                    .copyWith(color: AppColors.baseDark100, height: 1.h),
              ),

              SizedBox(height: 16.h),

              // Subtitle
              Text(
                "Account can be your bank, credit card or\nyour wallet.",
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.baseDark25,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // Continue Button
              FormButton(
                label: "Let's go",
                isEnabled: true,
                isLoading: false,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.newWallet
                  );
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
