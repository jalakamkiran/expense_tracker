import 'package:drift/drift.dart';
import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:get_it/get_it.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {


  WalletBloc() : super(WalletState.initial()) {
    on<WalletNameChanged>((e, emit) => emit(state.copyWith(name: e.name)));
    on<WalletTypeChanged>((e, emit) => emit(state.copyWith(accountType: e.type)));
    on<WalletBalanceChanged>((e, emit) => emit(state.copyWith(balance: e.balance)));

    on<WalletSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(WalletSubmitted event, Emitter<WalletState> emit) async {
    emit(state.copyWith(isSubmitting: true, isSuccess: false, errorMessage: null));
    try {
      final db = sl<AppDatabase>();
      await db.into(db.wallets).insert(
        WalletsCompanion.insert(
          name: state.name,
          accountType: state.accountType,
          balance: Value(state.balance),
        ),
      );
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
