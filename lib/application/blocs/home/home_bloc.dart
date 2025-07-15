import 'package:drift/drift.dart';
import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/transaction_dao.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/wallet/wallet_dao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeState.initial()) {
    on<LoadHomeData>(_onLoadData);
    on<ChangePeriod>((event, emit) {
      emit(state.copyWith(selectedPeriod: event.period));
    });
  }

  Future<void> _onLoadData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final db = sl<AppDatabase>();
      final transactions = await TransactionDao(db).getAllTransactions();
      final wallets = await WalletDao(db).getAllWallets();

      double income = 0;
      double expense = 0;

      for (final txn in transactions) {
        if (txn.type == 'Income') {
          income += txn.amount;
        } else if (txn.type == 'Expense') {
          expense += txn.amount;
        }
      }

      emit(state.copyWith(
        recentTransactions: transactions,
        wallets: wallets,
        totalIncome: income,
        totalExpense: expense,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
