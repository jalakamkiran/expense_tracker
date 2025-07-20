import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_event.dart';
import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_state.dart';
import 'package:expense_tracker_clean/application/blocs/form_bloc/form_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/form_bloc/form_event.dart';
import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/core/enums/transaction_category.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/categories/categories_dao.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_clean/presentation/widgets/app_drop_down.dart';
import 'package:expense_tracker_clean/presentation/widgets/app_text_field.dart';
import 'package:expense_tracker_clean/presentation/widgets/attachement_picker.dart';
import 'package:expense_tracker_clean/presentation/widgets/dotted_container.dart';
import 'package:expense_tracker_clean/presentation/widgets/form_button.dart';
import 'package:expense_tracker_clean/presentation/widgets/form_dialog.dart';
import 'package:expense_tracker_clean/presentation/widgets/repeat_toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionFormFields extends StatefulWidget {
  final TransactionType type;

  const TransactionFormFields({super.key, required this.type});

  @override
  State<TransactionFormFields> createState() => _TransactionFormFieldsState();
}

class _TransactionFormFieldsState extends State<TransactionFormFields> {
  List<String> walletOptions = [];

  @override
  void initState() {
    super.initState();
    _loadWallets();
  }

  Future<void> _loadWallets() async {
    final db = sl<AppDatabase>();
    final wallets = await db.walletDao.getAllWallets();
    setState(() {
      walletOptions = wallets.map((w) => w.name).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTransfer = widget.type == TransactionType.transfer;

    return BlocBuilder<AddTransactionBloc, AddTransactionAddState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              if (!isTransfer) ...[
                Row(
                  children: [
                    Expanded(
                      child: AppDropdown<String>(
                        title: 'Category',
                        hint: 'Select category',
                        selectedValue: state.category.isEmpty ? null : state.category,
                        items: state.availableCategories,
                        onChanged: (val) {
                          context
                              .read<AddTransactionBloc>()
                              .add(TransactionCategoryChanged(val));
                        },
                        itemBuilder: (value) => value.isEmpty
                            ? const SizedBox.shrink()
                            : _selectedCategoryTile(value),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    InkWell(
                        onTap: () async {
                          await _showFormDialog(context, FormType.category);
                        },
                        child: const Icon(
                          Icons.add,
                          color: AppColors.violet100,
                        ))
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: AppDropdown<String>(
                        title: 'Label',
                        hint: 'Select label',
                        selectedValue: (state.label != null && state.label!.isEmpty) ? null : state.label,
                        items: state.availableLabels,
                        onChanged: (val) {
                          context
                              .read<AddTransactionBloc>()
                              .add(TransactionLabelChanged(val));
                        },
                        itemBuilder: (value) => value.isEmpty
                            ? const SizedBox.shrink()
                            : _selectedCategoryTile(value),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    InkWell(
                        onTap: () async {
                          await _showFormDialog(context, FormType.label);
                        },
                        child: const Icon(
                          Icons.add,
                          color: AppColors.violet100,
                        )),
                  ],
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  title: 'Description',
                  hint: 'Enter description',
                  onChanged: (val) {
                    context
                        .read<AddTransactionBloc>()
                        .add(TransactionDescriptionChanged(val));
                  },
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: state.date,
                      firstDate: DateTime(now.year - 5),
                      lastDate: DateTime(now.year + 5),
                    );

                    if (picked != null) {
                      context
                          .read<AddTransactionBloc>()
                          .add(TransactionDateChanged(picked));
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.baseLight60, width: 1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: AppColors.baseDark50, size: 20.sp),
                        SizedBox(width: 12.w),
                        Text(
                          'Date: ${state.date.toLocal().toString().split(' ')[0]}',
                          style: AppTextStyles.body3
                              .copyWith(color: AppColors.baseDark100),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                _fromWalletDropdown(state, context),
                SizedBox(height: 16.h),
                AttachmentPicker(
                  selectedFile: state.attachment,
                  onFilePicked: (file) {
                    if (file != null) {
                      context
                          .read<AddTransactionBloc>()
                          .add(TransactionAttachmentAdded(file));
                    } else {
                      context
                          .read<AddTransactionBloc>()
                          .add(TransactionAttachmentRemoved());
                    }
                  },
                ),
                SizedBox(height: 16.h),
                RepeatToggleRow(
                  value: state.repeat,
                  onChanged: (val) {
                    context
                        .read<AddTransactionBloc>()
                        .add(TransactionRepeatToggled(val));
                  },
                ),
              ],
              if (isTransfer) ...[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _fromWalletDropdown(state, context)),
                        SizedBox(width: 16.w),
                        Expanded(child: _toWalletDropdown(state, context)),
                      ],
                    ),
                    SvgPicture.asset(Res.transfer),
                  ],
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  title: 'Description',
                  hint: 'Enter description',
                  onChanged: (val) {
                    context
                        .read<AddTransactionBloc>()
                        .add(TransactionDescriptionChanged(val));
                  },
                ),
                SizedBox(height: 16.h),
                AttachmentPicker(
                  selectedFile: state.attachment,
                  onFilePicked: (file) {
                    if (file != null) {
                      context
                          .read<AddTransactionBloc>()
                          .add(TransactionAttachmentAdded(file));
                    } else {
                      context
                          .read<AddTransactionBloc>()
                          .add(TransactionAttachmentRemoved());
                    }
                  },
                ),
              ],
              SizedBox(height: 24.h),
              FormButton(
                label: 'Continue',
                isEnabled: state.amount > 0 &&
                    state.category != null &&
                    state.category!.isNotEmpty &&
                    state.fromWallet != null &&
                    state.fromWallet!.isNotEmpty,
                isLoading: state.isSubmitting,
                onPressed: () {
                  state.type = widget.type;
                  context
                      .read<AddTransactionBloc>()
                      .add(TransactionSubmitted());
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showFormDialog(BuildContext context, FormType formType) async {
    await showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
          create: (_) => FormBloc(
            formType: formType,
          ),
          child: FormDialog(
            formType: formType,
            onSuccess: () async {
              if(formType == FormType.category){
                context.read<AddTransactionBloc>().add(LoadCategories());
              }
              else{
                context.read<AddTransactionBloc>().add(LoadLabels());
              }
            },
          ),
        );
      },
    );
  }

  Widget _fromWalletDropdown(
      AddTransactionAddState state, BuildContext context) {
    return AppDropdown<String>(
      title: 'From Wallet',
      hint: 'Select source wallet',
      selectedValue: state.fromWallet,
      items: walletOptions,
      onChanged: (val) {
        context
            .read<AddTransactionBloc>()
            .add(TransactionFromWalletChanged(val));
      },
      itemBuilder: (value) => Text(
        value,
        style: AppTextStyles.textFieldTextStyle.copyWith(
          color: AppColors.baseDark100,
        ),
      ),
    );
  }

  Widget _toWalletDropdown(AddTransactionAddState state, BuildContext context) {
    final filteredOptions =
        walletOptions.where((wallet) => wallet != state.fromWallet).toList();

    final isSelectedValid =
        state.toWallet != null && filteredOptions.contains(state.toWallet);

    return AppDropdown<String>(
      title: 'To Wallet',
      hint: 'Select destination wallet',
      selectedValue: isSelectedValid ? state.toWallet : null,
      items: filteredOptions,
      onChanged: (val) {
        if (val != state.fromWallet) {
          context
              .read<AddTransactionBloc>()
              .add(TransactionToWalletChanged(val));
        }
      },
      itemBuilder: (value) => Text(
        value,
        style: AppTextStyles.textFieldTextStyle.copyWith(
          color: value == state.fromWallet
              ? AppColors.baseLight20
              : AppColors.baseDark100,
        ),
      ),
    );
  }

  Container _selectedCategoryTile(String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: AppColors.baseLight60, width: 1.w),
        color: AppColors.baseLight80,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 6, backgroundColor: Colors.green),
          SizedBox(width: 8.w),
          Text(value),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }
}
