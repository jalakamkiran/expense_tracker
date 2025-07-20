import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  TextColumn get label => text()();
  TextColumn get wallet => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get attachment => text().nullable()();
  BoolColumn get repeat => boolean().withDefault(Constant(false))();
}
