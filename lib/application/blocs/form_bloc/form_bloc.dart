import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/categories/categories_dao.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/labels/label_dao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'form_event.dart';
import 'form_state.dart';
import '../../../data/datasources/local/app_database.dart';
import 'package:drift/drift.dart' as drift;

class FormBloc extends Bloc<FormEvent, FormState> {
  final FormType formType;

  FormBloc({required this.formType}) : super(FormState.initial()) {
    on<NameChanged>((event, emit) => emit(state.copyWith(name: event.name)));
    on<ColorChanged>((event, emit) => emit(state.copyWith(color: event.color)));
    on<IconChanged>((event, emit) => emit(state.copyWith(icon: event.icon)));

    on<SubmitForm>((event, emit) async {
      if (state.name.trim().isEmpty) {
        emit(state.copyWith(error: 'Name cannot be empty'));
        return;
      }

      emit(state.copyWith(isSubmitting: true));
      final db = sl<AppDatabase>();

      try {
        if (formType == FormType.category) {
          await db.categoryDao.insertCategory(
            CategoriesCompanion(
              name: drift.Value(state.name),
              color: drift.Value(state.color.value),
              iconCode: drift.Value(state.icon.codePoint),
            ),
          );
        } else {
          await db.labelDao.insertLabel(
            LabelsCompanion(
              name: drift.Value(state.name),
              color: drift.Value(state.color.value),
              iconCode: drift.Value(state.icon.codePoint),
            ),
          );
        }

        emit(state.copyWith(isSuccess: true));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), isSubmitting: false));
      }
    });
  }
}