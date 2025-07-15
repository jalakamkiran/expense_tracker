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

  const TransactionListLoaded({
    required this.groupedTransactions,
    required this.hasMore,
    required this.offset,
  });

  @override
  List<Object?> get props => [groupedTransactions, hasMore, offset];
}

class TransactionListError extends TransactionListState {
  final String message;
  const TransactionListError(this.message);
  @override
  List<Object?> get props => [message];
}
