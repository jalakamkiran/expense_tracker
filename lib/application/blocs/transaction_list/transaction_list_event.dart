// transaction_event.dart

import 'package:equatable/equatable.dart';

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
