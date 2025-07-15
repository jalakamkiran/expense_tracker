import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_event.dart';
import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_state.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_clean/presentation/screens/add_transaction/widgets/transaction_form_fields.dart';
import 'package:expense_tracker_clean/presentation/widgets/onboarding_app_bar.dart';
import 'package:expense_tracker_clean/presentation/widgets/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddTransactionScreen extends StatelessWidget {
  final TransactionType type;

  const AddTransactionScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: type.color,
      body: BlocListener<AddTransactionBloc, AddTransactionAddState>(
        listenWhen: (prev, curr) =>
        prev.isSuccess != curr.isSuccess ||
            prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.isSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const SuccessDialog(
                message: "Transaction added successfully!",
                imageAssetPath: Res.success,
              ),
            ).then((_) {
              Navigator.of(context).pop(); // Dismiss AddTransactionScreen
            });
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: BlocBuilder<AddTransactionBloc, AddTransactionAddState>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnBoardingAppBar(title: type.label),
                    SizedBox(height: 59.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        "How much?",
                        style: AppTextStyles.title2.copyWith(
                          color: AppColors.baseLight80.withOpacity(0.64),
                        ),
                      ),
                    ),
                    SizedBox(height: 13.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "₹",
                            style: AppTextStyles.title1.copyWith(
                              color: AppColors.baseLight80,
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              onChanged: (value) => _onAmountEdited(value, context),
                              keyboardType: TextInputType.number,
                              decoration: _amountTextDecoration(),
                              style: AppTextStyles.title1.copyWith(
                                color: AppColors.baseLight80,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: _formFieldDecoration(),
                      padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      child: TransactionFormFields(type: type),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration _formFieldDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.r),
        topRight: Radius.circular(32.r),
      ),
    );
  }

  void _onAmountEdited(String value, BuildContext context) {
    try {
      final amountValue = double.tryParse(value) ?? 0;
      context
          .read<AddTransactionBloc>()
          .add(TransactionAmountChanged(amountValue));
    } catch (_) {}
  }

  InputDecoration _amountTextDecoration() {
    return InputDecoration(
      hintText: "0",
      hintStyle: AppTextStyles.title1.copyWith(color: AppColors.baseLight80),
      border: InputBorder.none,
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: EdgeInsets.zero,
    );
  }
}