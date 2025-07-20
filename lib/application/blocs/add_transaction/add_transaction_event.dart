import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class AddTransactionEvent extends Equatable {
  const AddTransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionAmountChanged extends AddTransactionEvent {
  final double amount;

  const TransactionAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class TransactionCategoryChanged extends AddTransactionEvent {
  final String category;

  const TransactionCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class TransactionLabelChanged extends AddTransactionEvent {
  final String label;

  const TransactionLabelChanged(this.label);

  @override
  List<Object?> get props => [label];
}

class TransactionWalletChanged extends AddTransactionEvent {
  final String wallet;

  const TransactionWalletChanged(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class TransactionDescriptionChanged extends AddTransactionEvent {
  final String description;

  const TransactionDescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

class TransactionRepeatToggled extends AddTransactionEvent {
  final bool repeat;

  const TransactionRepeatToggled(this.repeat);

  @override
  List<Object?> get props => [repeat];
}

class TransactionAttachmentAdded extends AddTransactionEvent {
  final PlatformFile file;

  const TransactionAttachmentAdded(this.file);

  @override
  List<Object?> get props => [file];
}

class TransactionAttachmentRemoved extends AddTransactionEvent {}

class TransactionSubmitted extends AddTransactionEvent {}

class TransactionFromWalletChanged extends AddTransactionEvent {
  final String fromWallet;
  const TransactionFromWalletChanged(this.fromWallet);
}

class TransactionToWalletChanged extends AddTransactionEvent {
  final String toWallet;
  const TransactionToWalletChanged(this.toWallet);
}

class TransactionDateChanged extends AddTransactionEvent {
  final DateTime date;
  TransactionDateChanged(this.date);
}

class LoadCategories extends AddTransactionEvent {}


class LoadLabels extends AddTransactionEvent {}



