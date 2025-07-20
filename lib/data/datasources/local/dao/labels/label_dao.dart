import 'package:drift/drift.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/data/datasources/local/tables/labels.dart';

part 'label_dao.g.dart';

@DriftAccessor(tables: [Labels])
class LabelDao extends DatabaseAccessor<AppDatabase> with _$LabelDaoMixin {
  LabelDao(AppDatabase db) : super(db);

  Future<List<Label>> getAllLabels() => select(labels).get();

  Stream<List<Label>> watchAllLabels() => select(labels).watch();

  Future insertLabel(Insertable<Label> label) => into(labels).insert(label);

  Future deleteLabel(int id) => (delete(labels)..where((l) => l.id.equals(id))).go();
}
