import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {}

class ChangePeriod extends HomeEvent {
  final String period;
  const ChangePeriod(this.period);

  @override
  List<Object?> get props => [period];
}
