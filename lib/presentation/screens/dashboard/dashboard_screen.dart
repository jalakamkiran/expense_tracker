import 'package:expense_tracker_clean/application/blocs/bottom_nav_bar/bottom_nav_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/bottom_nav_bar/bottom_nav_event.dart';
import 'package:expense_tracker_clean/application/blocs/home/home_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/home/home_state.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/home/home_screen.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/transactions/transactions_screen.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/widgets/custom_fab_bar.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/home/widgets/month_dropdown.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/home/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/custom_bottom_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    TransactionsScreen(), // Transactions
    Placeholder(), // Budget
    Placeholder(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<BottomNavBloc>().state.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.baseLight100,
      floatingActionButton: const CustomFABBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          context.read<BottomNavBloc>().add(UpdateNavIndex(index));
        },
        currentIndex: currentIndex,
      ),
    );
  }
}
