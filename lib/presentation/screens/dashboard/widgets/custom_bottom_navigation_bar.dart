import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<NavigationItem> _items = [
    NavigationItem(
      icon: Res.home,
      selectedIcon: Res.homeSelected,
      label: 'Home',
    ),
    NavigationItem(
      icon: Res.transaction,
      selectedIcon: Res.transactionSelected,
      label: 'Transaction',
    ),
    NavigationItem(
      icon: Res.budget,
      selectedIcon: Res.budgetSelected,
      label: 'Budget',
    ),
    NavigationItem(
      icon: Res.profile,
      selectedIcon: Res.profileSelected,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = widget.currentIndex == index;

          return GestureDetector(
            onTap: () => widget.onTap(index),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    isSelected ? item.selectedIcon : item.icon,
                    width: 24.w,
                    height: 24.h,
                    color: isSelected ? AppColors.violet100 : AppColors.baseLight20,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.label,
                    style: AppTextStyles.body3.copyWith(
                      color: isSelected ? AppColors.violet100 : AppColors.baseLight20,
                      fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final String icon;
  final String selectedIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}