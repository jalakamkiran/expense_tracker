import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class WalletNameChanged extends WalletEvent {
  final String name;
  const WalletNameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class WalletTypeChanged extends WalletEvent {
  final String type;
  const WalletTypeChanged(this.type);
  @override
  List<Object?> get props => [type];
}

class WalletBalanceChanged extends WalletEvent {
  final double balance;
  const WalletBalanceChanged(this.balance);
  @override
  List<Object?> get props => [balance];
}

class WalletSubmitted extends WalletEvent {}
