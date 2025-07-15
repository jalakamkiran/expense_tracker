// lib/presentation/screens/dashboard/widgets/home_screen_body.dart

import 'package:expense_tracker_clean/application/blocs/home/home_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/home/home_event.dart';
import 'package:expense_tracker_clean/application/blocs/home/home_state.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:expense_tracker_clean/core/utils/app_functions.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/home/widgets/month_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/expense_cards.dart';
import 'widgets/expense_pie_chart.dart';
import 'widgets/recent_transactions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(LoadHomeData());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(child: Text('Error: ${state.error}')),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(LoadHomeData());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topContainerWidget(state),
                if (state.totalExpense > 0 || state.totalIncome > 0)
                  ExpensePieChart(
                    totalIncome: state.totalIncome,
                    totalExpense: state.totalExpense,
                  ),
                RecentTransactions(transactions: state.recentTransactions),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _topContainerWidget(HomeState state) {
    return Container(
      decoration: _headerContainerDecoration(),
      child: Column(
        children: [
          _buildHeader(),
          _buildAccountBalance(state),
          IncomeExpenseCards(
            income: state.totalIncome,
            expense: state.totalExpense,
          ),
          SizedBox(height: 23.h),
        ],
      ),
    );
  }

  BoxDecoration _headerContainerDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFFFF6E5), Color(0xFFFDF7EC)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            child: const Icon(Icons.person),
          ),
          const Spacer(),
          MonthDropdown(
            selectedMonth: 'July',
            onChanged: (val) {},
          ),
          const Spacer(),
          _notificationIcon(),
        ],
      ),
    );
  }

  SvgPicture _notificationIcon() {
    return SvgPicture.asset(
      Res.notification,
      width: 24.w,
      height: 24.h,
      color: AppColors.violet100,
    );
  }

  Widget _buildAccountBalance(HomeState state) {
    final balance = state.wallets.fold<double>(
      0,
          (sum, wallet) => sum + wallet.balance,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Text('Account Balance',
              style:
              AppTextStyles.body3.copyWith(color: AppColors.baseLight20)),
          SizedBox(height: 8.h),
          Text(
            AppFunctions().formatRupees(balance),
            style: AppTextStyles.title1.copyWith(
              color: AppColors.baseDark75,
              fontSize: 40.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}