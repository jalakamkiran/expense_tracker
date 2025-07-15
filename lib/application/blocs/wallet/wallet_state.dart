import 'package:equatable/equatable.dart';

class WalletState extends Equatable {
  final String name;
  final String accountType;
  final double balance;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const WalletState({
    required this.name,
    required this.accountType,
    required this.balance,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  factory WalletState.initial() => const WalletState(
    name: '',
    accountType: '',
    balance: 0.0,
  );

  WalletState copyWith({
    String? name,
    String? accountType,
    double? balance,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return WalletState(
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      balance: balance ?? this.balance,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [name, accountType, balance, isSubmitting, isSuccess, errorMessage];
}
