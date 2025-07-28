import 'package:expense_tracker_clean/application/blocs/bottom_nav_bar/bottom_nav_event.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_event.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_state.dart';
import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:expense_tracker_clean/core/res/res.dart';
import 'package:expense_tracker_clean/core/utils/app_functions.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/home/widgets/month_dropdown.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/home/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../application/blocs/bottom_nav_bar/bottom_nav_bloc.dart';
import 'widgets/filter_bottom_sheet/filter_bottom_sheet.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ScrollController _controller = ScrollController();
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    context.read<TransactionListBloc>().add(LoadTransactions());

    _controller.addListener(() {
      final bloc = context.read<TransactionListBloc>();
      final state = bloc.state;
      if (state is TransactionListLoaded &&
          _controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          state.hasMore) {
        bloc.add(LoadTransactions(month: _selectedMonth));
      }
    });
  }



  @override
  Widget build(BuildContext transactionContext) {
    return WillPopScope(
      onWillPop: () async {
        if (transactionContext.read<BottomNavBloc>().state.currentIndex != 0) {
          transactionContext.read<BottomNavBloc>().add(const UpdateNavIndex(0));
          return false;
        }
        return true; // allow the pop
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                MonthDropdown(
                  selectedMonth: _selectedMonth,
                  onChanged: (val) {
                    setState(() => _selectedMonth = val);
                    transactionContext.read<TransactionListBloc>().add(
                        ResetTransactions(month: val)); // 🔁 Reset with filter
                  },
                ),
                const Spacer(),

                /// 🔽 Reset Filter Button
                TextButton(
                  onPressed: () {
                    setState(() => _selectedMonth = null);
                    transactionContext
                        .read<TransactionListBloc>()
                        .add(const ResetTransactions());
                  },
                  child: Text(
                    'Reset Filter',
                    style: AppTextStyles.body3.copyWith(
                      color: AppColors.violet100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.receipt_long,
                    color: AppColors.violet100,
                    size: 24.sp,
                  ),
                  onSelected: (value) {
                    final state = transactionContext.read<TransactionListBloc>().state;
                    if (state is TransactionListLoaded) {
                      final allTxns = state.groupedTransactions.values.expand((e) => e).toList();
                      ScaffoldMessenger.of(transactionContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Building receipt for ${allTxns.length} transactions',
                          ),
                        ),
                      );
                      AppFunctions().shareReceipt(allTxns);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'share_selected', child: Text('Share Selected')),
                    const PopupMenuItem(value: 'share_all', child: Text('Share All')),
                  ],
                ),


                SizedBox(width: 8.w),
                InkWell(
                  onTap: () async {
                    await _onFilterTapped(transactionContext);
                  },
                  child:
                      SvgPicture.asset(Res.filter, width: 24.w, height: 24.h),
                ),
              ],
            ),
          ),


          Expanded(
            child: BlocBuilder<TransactionListBloc, TransactionListState>(
              builder: (context, state) {
                if (state is TransactionListLoading ||
                    state is TransactionListInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionListLoaded) {
                  final grouped = state.groupedTransactions;

                  final totalIncome = state.totalIncome;
                  final totalExpense = state.totalExpense;
                  final totalAmount = state.totalAmount;

                  final net = totalIncome - totalExpense;
                  final isProfit = net >= 0;

                  // Handle empty state with pull-to-refresh
                  if (grouped.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<TransactionListBloc>()
                            .add(ResetTransactions(month: _selectedMonth));
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: const Center(
                              child: Text('No transactions found'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<TransactionListBloc>()
                          .add(ResetTransactions(month: _selectedMonth));
                    },
                    child: ListView.builder(
                      controller: _controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 0, left: 16.w, right: 16.w, bottom: 16.h),
                      itemCount: grouped.length + 1 + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildSummaryCard(state);
                        }

                        final adjustedIndex = index - 1;

                        if (adjustedIndex == grouped.length) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final date = grouped.keys.elementAt(adjustedIndex);
                        final txns = grouped[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(date,
                                style: AppTextStyles.title3.copyWith(color: AppColors.baseDark100)),
                            SizedBox(height: 8.h),
                            ...txns.map((txn) => TransactionTile(transaction: txn))
                          ],
                        );
                      },
                    )
                    ,
                  );
                } else if (state is TransactionListError) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<TransactionListBloc>()
                          .add(ResetTransactions(month: _selectedMonth));
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(child: Text(state.message)),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryCard(TransactionListLoaded state) {
    final totalIncome = state.totalIncome;
    final totalExpense = state.totalExpense;
    final net = totalIncome - totalExpense;
    final isProfit = net >= 0;

     return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.baseLight80,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.baseDark25.withOpacity(0.3),width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Summary", style: AppTextStyles.title3),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem("Income", totalIncome, AppColors.green100),
                _buildSummaryItem("Expense", totalExpense, AppColors.red100),
                _buildSummaryItem("Net", net, isProfit ? AppColors.green100 : AppColors.red100),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _onFilterTapped(BuildContext transactionContext) async {
    final db = sl<AppDatabase>();
    List<Category> categories = await db.categoryDao.getAllCategories();
    List<Label> labels = await db.labelDao.getAllLabels();
    if (transactionContext.mounted) {
      showModalBottomSheet(
        context: transactionContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => BlocProvider.value(
          value: transactionContext.read<TransactionListBloc>(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) =>
                FilterTransactionBottomSheet(
              categories: categories,
              labels: labels,
              onApply: (filterData) {
                transactionContext
                    .read<TransactionListBloc>()
                    .add(FilterTransactions(
                      filterData: filterData,
                      month: AppFunctions().computeMonthIndex(
                          _selectedMonth), // Pass current month
                    ));
              },
            ),
          ),
        ),
      );
    }
  }

  Widget _buildSummaryItem(String title, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.body2.copyWith(color: AppColors.baseDark100)),
        SizedBox(height: 4.h),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: AppTextStyles.title3.copyWith(color: color),
        ),
      ],
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
