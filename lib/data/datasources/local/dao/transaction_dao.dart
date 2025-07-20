import 'package:drift/drift.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/data/datasources/local/tables/transactions.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Future<List<Transaction>> getAllTransactions() => select(transactions).get();
  Stream<List<Transaction>> watchAllTransactions() => select(transactions).watch();
  Future insertTransaction(Insertable<Transaction> txn) => into(transactions).insert(txn);
  Future deleteTransaction(int id) => (delete(transactions)..where((t) => t.id.equals(id))).go();


  Future<List<Transaction>> getTransactionsByMonth(int? month) async {
    final query = select(transactions);

    if (month != null) {
      final now = DateTime.now();
      final year = now.year;

      final start = DateTime(year, month, 1);
      final end = (month < 12)
          ? DateTime(year, month + 1, 1).subtract(const Duration(days: 1))
          : DateTime(year + 1, 1, 1).subtract(const Duration(days: 1));

      query.where((tbl) =>
          tbl.date.isBetweenValues(start, end));
    }

    return query.get();
  }

}
