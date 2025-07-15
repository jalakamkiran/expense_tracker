import 'package:equatable/equatable.dart';

abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();

  @override
  List<Object?> get props => [];
}

class UpdateNavIndex extends BottomNavEvent {
  final int index;
  const UpdateNavIndex(this.index);

  @override
  List<Object?> get props => [index];
}
