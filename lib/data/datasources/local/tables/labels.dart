import 'package:drift/drift.dart';

class Labels extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  IntColumn get color => integer()();

  IntColumn get iconCode => integer()();
}
