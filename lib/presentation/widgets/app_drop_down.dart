import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppDropdown<T> extends StatelessWidget {
  final String title;
  final String hint;
  final T? selectedValue;
  final List<T> items;
  final void Function(T) onChanged;
  final Widget Function(T)? itemBuilder;

  const AppDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE3E5E5), width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: selectedValue,
          isExpanded: true,
          icon: SvgPicture.asset(Res.arrowDown),
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder != null
                  ? itemBuilder!(item)
                  : Text(item.toString()),
            );
          }).toList(),
        ),
      ),
    );
  }
}
