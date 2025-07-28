import 'package:equatable/equatable.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';

abstract class TransactionListState extends Equatable {
  const TransactionListState();

  @override
  List<Object?> get props => [];
}

class TransactionListInitial extends TransactionListState {}

class TransactionListLoading extends TransactionListState {}


class TransactionListLoaded extends TransactionListState {
  final Map<String, List<Transaction>> groupedTransactions;
  final bool hasMore;
  final int offset;

  final double totalAmount;
  final double totalIncome;
  final double totalExpense;

  TransactionListLoaded({
    required this.groupedTransactions,
    required this.hasMore,
    required this.offset,
    required this.totalAmount,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  List<Object?> get props => [groupedTransactions, hasMore, offset,totalAmount,totalIncome,totalExpense];
}

class TransactionListError extends TransactionListState {
  final String message;
  const TransactionListError(this.message);
  @override
  List<Object?> get props => [message];
}
