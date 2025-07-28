import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_event.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_state.dart';
import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/transactions/widgets/filter_bottom_sheet/filter_bottom_sheet.dart';
import 'package:intl/intl.dart';

class TransactionListBloc
    extends Bloc<TransactionListEvent, TransactionListState> {
  static const int _pageSize = 20;

  TransactionListBloc() : super(TransactionListInitial()) {
    on<LoadTransactions>(_onLoad);
    on<ResetTransactions>(_onReset);
    on<DeleteTransaction>(_onDelete);
    on<FilterTransactions>(_onFilter);
  }

  Future<void> _onReset(
      ResetTransactions event, Emitter<TransactionListState> emit) async {
    emit(TransactionListInitial());
    add(LoadTransactions(month: event.month));
  }

  Future<void> _onLoad(
      LoadTransactions event,
      Emitter<TransactionListState> emit,
      ) async {
    try {
      final db = sl<AppDatabase>();

      final offset = (state is TransactionListLoaded)
          ? (state as TransactionListLoaded).offset
          : 0;

      final transactions = await db.getTransactionsPaginated(
        offset: offset,
        limit: _pageSize,
        month: event.month,
      );

      transactions.sort((a, b) => b.date.compareTo(a.date));
      final newGrouped = _groupByDay(transactions);

      Map<String, List<Transaction>> prevGrouped =
      state is TransactionListLoaded
          ? Map.from((state as TransactionListLoaded).groupedTransactions)
          : {};

      for (var key in newGrouped.keys) {
        if (prevGrouped.containsKey(key)) {
          prevGrouped[key]!.addAll(newGrouped[key]!);
        } else {
          prevGrouped[key] = newGrouped[key]!;
        }
      }

      // Flatten all transactions
      final allTxns = prevGrouped.values.expand((list) => list).toList();

      final totalIncome = allTxns
          .where((t) => t.type.toLowerCase() == 'income')
          .fold(0.0, (sum, t) => sum + t.amount);

      final totalExpense = allTxns
          .where((t) => t.type.toLowerCase() == 'expense')
          .fold(0.0, (sum, t) => sum + t.amount);

      final totalAmount = allTxns.fold(0.0, (sum, t) => sum + t.amount);

      emit(TransactionListLoaded(
        groupedTransactions: prevGrouped,
        hasMore: transactions.length == _pageSize,
        offset: offset + transactions.length,
        totalAmount: totalAmount,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      ));
    } catch (e) {
      emit(TransactionListError(e.toString()));
    }
  }


  Map<String, List<Transaction>> _groupByDay(List<Transaction> txns) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateFormat = DateFormat('dd MMM yyyy');

    final Map<String, List<Transaction>> grouped = {};

    for (final txn in txns) {
      final txnDate = DateTime(txn.date.year, txn.date.month, txn.date.day);
      final label = txnDate == today
          ? "Today"
          : txnDate == yesterday
              ? "Yesterday"
              : dateFormat.format(txnDate);

      grouped.putIfAbsent(label, () => []).add(txn);
    }

    return grouped;
  }

  Future<void> _onDelete(
      DeleteTransaction event, Emitter<TransactionListState> emit) async {
    final db = sl<AppDatabase>();
    final walletDao = db.walletDao;
    final txnDao = db.transactionDao;

    final txn = event.transaction;
    final txnType = txn.type;
    final amount = txn.amount;
    final fromWallet = txn.wallet; // assuming this is the source wallet name
    // final toWallet = txn.toWallet; // assuming null for non-transfers

    try {
      // 🔁 Rollback wallet balances based on txn type
      switch (txnType.toLowerCase()) {
        case 'income':
          await walletDao.updateBalanceByName(fromWallet, -amount);
          break;

        case 'expense':
          await walletDao.updateBalanceByName(fromWallet, amount);
          break;

        case 'transfer':
          // await walletDao.updateBalanceByName(fromWallet, amount);
          // if (toWallet != null) {
          //   await walletDao.updateBalanceByName(toWallet, -amount);
          // }
          break;
      }

      // 🗑️ Delete transaction
      await txnDao.deleteTransaction(txn.id);

      // ✅ Refresh transaction list
      add(const ResetTransactions()); // Will call LoadTransactions again
    } catch (e) {
      emit(TransactionListError(
          "Failed to delete transaction: ${e.toString()}"));
    }
  }

  Future<void> _onFilter(
    FilterTransactions event,
    Emitter<TransactionListState> emit,
  ) async {
    try {
      final db = sl<AppDatabase>();
      final allTxns = await db.transactionDao
          .getTransactionsByMonth(event.month); // Custom method

      List<Transaction> filtered = allTxns;

      // 🧾 Filter by type
      if (event.filterData.transactionType != null) {
        filtered = filtered
            .where((txn) =>
                txn.type ==
                event.filterData.transactionType!.name.toLowerCase())
            .toList();
      }

      // 🏷️ Filter by categories (matching by category name)
      if (event.filterData.selectedCategories.isNotEmpty) {
        final categoryNames = event.filterData.selectedCategories
            .map((c) => c.name.toLowerCase())
            .toSet();
        filtered = filtered
            .where((txn) => categoryNames.contains(txn.category.toLowerCase()))
            .toList();
      }

// 🧩 Filter by labels (assuming a transaction can have multiple labels as comma-separated string or list)
      // 🧩 Filter by labels (matching by name)
      if (event.filterData.selectedLabels.isNotEmpty) {
        final selectedLabelNames = event.filterData.selectedLabels
            .map((l) => l.name.toLowerCase())
            .toSet();

        filtered = filtered
            .where(
                (txn) => selectedLabelNames.contains(txn.label.toLowerCase()))
            .toList();
      }

      // ↕️ Sort
      switch (event.filterData.sortType) {
        case SortType.highest:
          filtered.sort((a, b) => b.amount.compareTo(a.amount));
          break;
        case SortType.lowest:
          filtered.sort((a, b) => a.amount.compareTo(b.amount));
          break;
        case SortType.newest:
          filtered.sort((a, b) => b.date.compareTo(a.date));
          break;
        case SortType.oldest:
          filtered.sort((a, b) => a.date.compareTo(b.date));
          break;
        default:
          break;
      }

      final grouped = _groupByDay(filtered);

      final totalIncome = filtered
          .where((t) => t.type.toLowerCase() == 'income')
          .fold(0.0, (sum, t) => sum + t.amount);

      final totalExpense = filtered
          .where((t) => t.type.toLowerCase() == 'expense')
          .fold(0.0, (sum, t) => sum + t.amount);

      final totalAmount = filtered.fold(0.0, (sum, t) => sum + t.amount);

      emit(TransactionListLoaded(
        groupedTransactions: grouped,
        hasMore: false,
        offset: filtered.length,
        totalAmount: totalAmount,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      ));
    } catch (e) {
      emit(TransactionListError("Filter failed: ${e.toString()}"));
    }
  }
}
