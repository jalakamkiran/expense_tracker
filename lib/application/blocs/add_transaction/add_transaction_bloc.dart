import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_event.dart';
import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_state.dart';
import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/wallet/wallet_dao.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

class AddTransactionBloc extends Bloc<AddTransactionEvent, AddTransactionAddState> {
  AddTransactionBloc() : super(AddTransactionAddState.initial()) {
    on<TransactionAmountChanged>(_onAmountChanged);
    on<TransactionCategoryChanged>(_onCategoryChanged);
    on<TransactionWalletChanged>(_onWalletChanged);
    on<TransactionDescriptionChanged>(_onDescriptionChanged);
    on<TransactionRepeatToggled>(_onRepeatToggled);
    on<TransactionAttachmentAdded>(_onAttachmentAdded);
    on<TransactionAttachmentRemoved>(_onAttachmentRemoved);
    on<TransactionSubmitted>(_onSubmitted);
    on<TransactionToWalletChanged>(_onToWalletChanged);
    on<TransactionFromWalletChanged>(_onFromWalletChanged);
    on<TransactionDateChanged>(_onDateChanged);
  }

  void _onAmountChanged(TransactionAmountChanged event, Emitter<AddTransactionAddState> emit) {
    emit(state.copyWith(amount: event.amount));
  }

  void _onCategoryChanged(TransactionCategoryChanged event, Emitter<AddTransactionAddState> emit) {
    emit(state.copyWith(category: event.category));
  }

  void _onWalletChanged(TransactionWalletChanged event, Emitter<AddTransactionAddState> emit) {
    emit(state.copyWith(toWallet: event.wallet));
  }

  void _onDescriptionChanged(TransactionDescriptionChanged event, Emitter<AddTransactionAddState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onRepeatToggled(TransactionRepeatToggled event, Emitter<AddTransactionAddState> emit) {
    emit(state.copyWith(repeat: event.repeat));
  }

  void _onAttachmentAdded(TransactionAttachmentAdded event, Emitter<AddTransactionAddState> emit) {
    emit(state.copyWith(attachment: event.file, attachmentHasChanged: true));
  }

  void _onAttachmentRemoved(TransactionAttachmentRemoved event, Emitter<AddTransactionAddState> emit) {
    emit(state.copyWith(attachment: null, attachmentHasChanged: true));
  }

  void _onFromWalletChanged(TransactionFromWalletChanged event, Emitter<AddTransactionAddState> emit) {
    final newFrom = event.fromWallet;
    final newTo = state.toWallet == newFrom ? null : state.toWallet;
    emit(state.copyWith(fromWallet: newFrom, toWallet: newTo));
  }

  void _onToWalletChanged(TransactionToWalletChanged event, Emitter<AddTransactionAddState> emit) {
    emit(state.copyWith(toWallet: event.toWallet, fromWallet: state.fromWallet));
  }

  Future<void> _onSubmitted(
      TransactionSubmitted event,
      Emitter<AddTransactionAddState> emit,
      ) async {
    emit(state.copyWith(
      isSubmitting: true,
      isSuccess: false,
      errorMessage: null,
    ));

    try {
      if (state.amount <= 0) throw Exception("Amount must be greater than 0");
      if (state.category == null) throw Exception("Category is required");

      final db = sl<AppDatabase>();
      final walletDao = WalletDao(db);

      // 💾 Save to DB
      await db.into(db.transactions).insert(
        TransactionsCompanion.insert(
          title: state.description.isEmpty ? "Untitled" : state.description,
          amount: state.amount,
          category: state.category!,
          wallet: state.type == TransactionType.transfer
              ? "${state.fromWallet} → ${state.toWallet}"
              : (state.fromWallet ?? state.toWallet ?? "Wallet"),
          type: state.type.label,
          date: state.date,
          description: Value(state.description),
          attachment: Value(state.attachment?.name),
          repeat: Value(state.repeat),
        ),
      );

      // 🏦 Update Wallet Balance based on type
      switch (state.type) {
        case TransactionType.income:
          if (state.fromWallet != null) {
            await walletDao.updateBalanceByName(state.fromWallet!, state.amount);
          }
          break;

        case TransactionType.expense:
          if (state.fromWallet != null) {
            await walletDao.updateBalanceByName(state.fromWallet!, -state.amount);
          }
          break;

        case TransactionType.transfer:
          if (state.fromWallet != null) {
            await walletDao.updateBalanceByName(state.fromWallet!, -state.amount);
          }
          if (state.toWallet != null) {
            await walletDao.updateBalanceByName(state.toWallet!, state.amount);
          }
          break;
      }

      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onDateChanged(TransactionDateChanged event, Emitter<AddTransactionAddState> emit) {
    emit(state.copyWith(date: event.date));
  }

}
