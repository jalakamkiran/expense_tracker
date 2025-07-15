import 'package:equatable/equatable.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/data/datasources/local/tables/transactions.dart';
import 'package:expense_tracker_clean/data/datasources/local/tables/wallets.dart';

class HomeState extends Equatable {
  final List<Transaction> recentTransactions;
  final List<Wallet> wallets;
  final double totalIncome;
  final double totalExpense;
  final String selectedPeriod;
  final bool isLoading;
  final String? error;

  const HomeState({
    required this.recentTransactions,
    required this.wallets,
    required this.totalIncome,
    required this.totalExpense,
    required this.selectedPeriod,
    this.isLoading = false,
    this.error,
  });

  factory HomeState.initial() => const HomeState(
    recentTransactions: [],
    wallets: [],
    totalIncome: 0,
    totalExpense: 0,
    selectedPeriod: 'Today',
    isLoading: true,
  );

  HomeState copyWith({
    List<Transaction>? recentTransactions,
    List<Wallet>? wallets,
    double? totalIncome,
    double? totalExpense,
    String? selectedPeriod,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      recentTransactions: recentTransactions ?? this.recentTransactions,
      wallets: wallets ?? this.wallets,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    recentTransactions,
    wallets,
    totalIncome,
    totalExpense,
    selectedPeriod,
    isLoading,
    error,
  ];
}
