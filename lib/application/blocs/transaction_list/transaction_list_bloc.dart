import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_event.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_state.dart';
import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:intl/intl.dart';

class TransactionListBloc extends Bloc<TransactionListEvent, TransactionListState> {
  static const int _pageSize = 20;

  TransactionListBloc() : super(TransactionListInitial()) {
    on<LoadTransactions>(_onLoad);
    on<ResetTransactions>(_onReset);
  }

  Future<void> _onReset(ResetTransactions event, Emitter<TransactionListState> emit) async {
    emit(TransactionListInitial());
    add(LoadTransactions(month: event.month));
  }

  Future<void> _onLoad(LoadTransactions event, Emitter<TransactionListState> emit) async {
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

      Map<String, List<Transaction>> prev = state is TransactionListLoaded
          ? Map.from((state as TransactionListLoaded).groupedTransactions)
          : {};

      for (var key in newGrouped.keys) {
        if (prev.containsKey(key)) {
          prev[key]!.addAll(newGrouped[key]!);
        } else {
          prev[key] = newGrouped[key]!;
        }
      }

      emit(TransactionListLoaded(
        groupedTransactions: prev,
        hasMore: transactions.length == _pageSize,
        offset: offset + transactions.length,
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
}
