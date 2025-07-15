import 'package:expense_tracker_clean/application/blocs/wallet/wallet_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/wallet/wallet_event.dart';
import 'package:expense_tracker_clean/application/blocs/wallet/wallet_state.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/routes/routes.dart';
import 'package:expense_tracker_clean/presentation/widgets/app_drop_down.dart';
import 'package:expense_tracker_clean/presentation/widgets/app_text_field.dart';
import 'package:expense_tracker_clean/presentation/widgets/form_button.dart';
import 'package:expense_tracker_clean/presentation/widgets/onboarding_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateNewWalletScreen extends StatelessWidget {
  const CreateNewWalletScreen({super.key});

  final List<String> _accountTypes = const [
    'Bank',
    'Credit Card',
    'Wallet',
    'Investment'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.violet100,
      // Add resizeToAvoidBottomInset to handle keyboard overflow
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocListener<WalletBloc, WalletState>(
          listenWhen: (prev, curr) =>
          prev.isSuccess != curr.isSuccess ||
              prev.errorMessage != curr.errorMessage,
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Wallet created successfully!"),
                  backgroundColor: AppColors.violet100,
                ),
              );
              Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          // Wrap with SingleChildScrollView to prevent overflow
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: Column(
                children: [
                  const OnBoardingAppBar(title: "Add new wallet"),
                  const Spacer(),
                  _buildBalanceSection(context),
                  const Spacer(),
                  _buildFormSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Balance",
            style: AppTextStyles.body1.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 8.h),
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "₹",
                    style: AppTextStyles.title1.copyWith(color: AppColors.baseLight80),
                  ),
                  Flexible(
                    child: IntrinsicWidth(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: state.balance == 0 ? "" : state.balance.toStringAsFixed(0),
                        onChanged: (value) {
                          final parsed = double.tryParse(value) ?? 0;
                          context
                              .read<WalletBloc>()
                              .add(WalletBalanceChanged(parsed));
                        },
                        decoration: _amountTextDecoration(),
                        style: AppTextStyles.title1
                            .copyWith(color: AppColors.baseLight80),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _amountTextDecoration() {
    return InputDecoration(
      hintText: "0",
      border: InputBorder.none,
      isDense: true,
      hintStyle: AppTextStyles.title1.copyWith(color: AppColors.baseLight80),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            final isFormValid =
                state.name.isNotEmpty && state.accountType.isNotEmpty;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24.h),
                AppTextField(
                  title: "Name",
                  hint: "Name",
                  onChanged: (val) =>
                      context.read<WalletBloc>().add(WalletNameChanged(val)),
                ),
                SizedBox(height: 24.h),
                AppDropdown<String>(
                  title: "Account Type",
                  hint: "Account Type",
                  selectedValue:
                  state.accountType.isEmpty ? null : state.accountType,
                  items: _accountTypes,
                  onChanged: (val) =>
                      context.read<WalletBloc>().add(WalletTypeChanged(val)),
                  itemBuilder: (val) => Text(
                    val,
                    style: AppTextStyles.textFieldTextStyle
                        .copyWith(color: AppColors.baseDark100),
                  ),
                ),
                SizedBox(height: 32.h),
                FormButton(
                  label: "Continue",
                  isEnabled: isFormValid,
                  isLoading: state.isSubmitting,
                  onPressed: () =>
                      context.read<WalletBloc>().add(WalletSubmitted()),
                ),
                SizedBox(height: 24.h),
              ],
            );
          },
        ),
      ),
    );
  }
}