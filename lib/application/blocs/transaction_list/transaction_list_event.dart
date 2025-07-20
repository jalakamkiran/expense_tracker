// transaction_event.dart

import 'package:equatable/equatable.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/transactions/widgets/filter_bottom_sheet/filter_bottom_sheet.dart';

abstract class TransactionListEvent extends Equatable {
  const TransactionListEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionListEvent {
  final String? month;

  const LoadTransactions({this.month});

  @override
  List<Object?> get props => [month];
}

class ResetTransactions extends TransactionListEvent {
  final String? month;

  const ResetTransactions({this.month});

  @override
  List<Object?> get props => [month];
}

class DeleteTransaction extends TransactionListEvent {
  final Transaction transaction;

  const DeleteTransaction({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class FilterTransactions extends TransactionListEvent {
  final FilterData filterData;
  final int? month;

  const FilterTransactions({required this.filterData, this.month});

}


