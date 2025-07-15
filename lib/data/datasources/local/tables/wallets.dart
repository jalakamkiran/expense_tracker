import 'package:drift/drift.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get accountType => text()();
  RealColumn get balance => real().withDefault(Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}
