import 'package:equatable/equatable.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:file_picker/file_picker.dart';

class AddTransactionAddState extends Equatable {
  final double amount;
  final String category;
  final String? label;
  final String description;
  final bool repeat;
  final PlatformFile? attachment;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  TransactionType type;
  final String? fromWallet;
  final String? toWallet;
  final DateTime date;
  final List<String> availableCategories;
  final List<String> availableLabels;


  AddTransactionAddState({
    required this.amount,
    required this.category,
    required this.description,
    required this.repeat,
    required this.type,
    this.label = "",
    required this.date,
    this.attachment,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.fromWallet,
    this.toWallet,
    this.availableCategories = const [],
    this.availableLabels = const [],
  });

  factory AddTransactionAddState.initial() => AddTransactionAddState(
    amount: 0.0,
    category: '',
    description: '',
    label: '',
    repeat: false,
    type: TransactionType.expense,
    date: DateTime.now(),
  );

  AddTransactionAddState copyWith({
    double? amount,
    String? category,
    String? wallet,
    String? description,
    bool? repeat,
    bool attachmentHasChanged = false,
    PlatformFile? attachment,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    TransactionType? type,
    String? fromWallet,
    String? label,
    String? toWallet,
    DateTime? date,
    List<String>? availableCategories,
    List<String>? availableLabels,
  }) {
    return AddTransactionAddState(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      fromWallet: fromWallet ?? this.fromWallet,
      toWallet: toWallet ?? this.toWallet,
      description: description ?? this.description,
      repeat: repeat ?? this.repeat,
      availableCategories: availableCategories ?? this.availableCategories,
      type: type ?? this.type,
      date: date ?? this.date,
      label: label ?? this.label,
      availableLabels: availableLabels ?? this.availableLabels,
      attachment: attachmentHasChanged ? attachment : this.attachment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    amount,
    category,
    description,
    repeat,
    attachment,
    isSubmitting,
    isSuccess,
    errorMessage,
    fromWallet,
    toWallet,
    date,
    label,
    availableCategories,
    type,
    availableLabels
  ];
}
