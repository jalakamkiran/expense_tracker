import 'package:expense_tracker_clean/application/blocs/bottom_nav_bar/bottom_nav_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/bottom_nav_bar/bottom_nav_event.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/home/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactions({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Transactions',
                  style: AppTextStyles.title3.copyWith(
                      color: AppColors.baseDark100,
                      fontWeight: FontWeight.w600)),
              InkWell(
                onTap: () {
                  context.read<BottomNavBloc>().add(const UpdateNavIndex(1));
                },
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.violet100.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Text('See All',
                      style: AppTextStyles.body3.copyWith(
                          color: AppColors.violet100,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          transactions.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transactions.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, index) =>
                TransactionTile(transaction: transactions[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Text('No transactions yet',
              style: AppTextStyles.title3.copyWith(
                  color: AppColors.baseDark100, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Text('Start by adding your first transaction',
              style:
              AppTextStyles.body3.copyWith(color: AppColors.baseLight20)),
        ],
      ),
    );
  }
}
