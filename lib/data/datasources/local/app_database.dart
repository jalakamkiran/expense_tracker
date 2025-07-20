import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/categories/categories_dao.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/labels/label_dao.dart';
import 'package:expense_tracker_clean/data/datasources/local/tables/labels.dart';
import 'package:expense_tracker_clean/data/datasources/local/tables/transactions.dart';
import 'package:expense_tracker_clean/data/datasources/local/tables/wallets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'dao/transaction_dao.dart';
import 'dao/wallet/wallet_dao.dart';
import 'tables/categories.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Transactions,Wallets,Categories,Labels],
  daos: [TransactionDao,WalletDao,CategoryDao,LabelDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Transaction>> getTransactionsPaginated({
    int offset = 0,
    int limit = 20,
    String? month,
  }) {
    final query = select(transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)])
      ..limit(limit, offset: offset);

    if (month != null) {
      final monthIndex = DateFormat.MMMM().parse(month).month;
      final now = DateTime.now();
      final startDate = DateTime(now.year, monthIndex, 1);
      final endDate = monthIndex == 12
          ? DateTime(now.year + 1, 1, 1).subtract(const Duration(seconds: 1))
          : DateTime(now.year, monthIndex + 1, 1).subtract(const Duration(seconds: 1));

      query.where((t) =>
      t.date.isBiggerOrEqualValue(startDate) &
      t.date.isSmallerOrEqualValue(endDate));
    }

    return query.get();
  }


  int _getMonthIndex(String month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames.indexOf(month) + 1;
  }


}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'expense_tracker_clean.sqlite'));
    return NativeDatabase(file,logStatements: true);
  });
}
