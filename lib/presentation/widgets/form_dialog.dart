// form_dialog.dart

import 'dart:async';

import 'package:expense_tracker_clean/application/blocs/form_bloc/form_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/form_bloc/form_event.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/presentation/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FormDialog extends StatefulWidget {
  final FormType formType;
  final Future<void> Function()? onSuccess;

  const FormDialog({
    super.key,
    required this.formType,
    this.onSuccess,
  });

  @override
  State<FormDialog> createState() => _FormDialogState();
}


class _FormDialogState extends State<FormDialog> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedColor = Colors.blue.value;
  IconData _selectedIcon = Icons.category;

  void _pickColor() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: Color(_selectedColor),
            onColorChanged: (color) {
              setState(() => _selectedColor = color.value);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  void _pickIcon() async {
    final List<IconData> icons = [
      Icons.category,
      Icons.label,
      Icons.shopping_cart,
      Icons.fastfood,
      Icons.attach_money,
      Icons.money_off,
    ];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick an icon"),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: icons.length,
            itemBuilder: (_, index) {
              return IconButton(
                icon: Icon(icons[index]),
                onPressed: () {
                  setState(() => _selectedIcon = icons[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final bloc = context.read<FormBloc>();

    bloc.add(NameChanged(name));
    bloc.add(ColorChanged(Color(_selectedColor)));
    bloc.add(IconChanged(_selectedIcon));
    bloc.add(const SubmitForm());

    StreamSubscription? subscription;

    subscription = bloc.stream.listen((state) async {
      if (state.isSuccess) {
        subscription?.cancel();
        if (widget.onSuccess != null) {
          await widget.onSuccess!();
        }
        if (context.mounted) {
          Navigator.pop(context); // Only pop after success
        }
      }

      if (state.error != null) {
        subscription?.cancel();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.formType == FormType.category ? "Create Category" : "Create Label",
              style: AppTextStyles.textFieldTextStyle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              title: "Name",
              hint: "Enter name",
              controller: _nameController,
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: _pickColor,
              child: Container(
                width: double.infinity,
                height: 56.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.baseLight60),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    const Text("Pick Color"),
                    const Spacer(),
                    CircleAvatar(backgroundColor: Color(_selectedColor), radius: 12.r),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: _pickIcon,
              child: Container(
                width: double.infinity,
                height: 56.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.baseLight60),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    const Text("Pick Icon"),
                    const Spacer(),
                    Icon(_selectedIcon),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
