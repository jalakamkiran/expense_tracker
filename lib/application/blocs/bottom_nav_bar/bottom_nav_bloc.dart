import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_event.dart';
import 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState(0)) {
    on<UpdateNavIndex>((event, emit) {
      emit(BottomNavState(event.index));
    });
  }
}
