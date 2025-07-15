import 'package:drift/drift.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/data/datasources/local/tables/wallets.dart';

part 'wallet_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  WalletDao(AppDatabase db) : super(db);

  Future<List<Wallet>> getAllWallets() => select(wallets).get();

  Stream<List<Wallet>> watchAllWallets() => select(wallets).watch();

  Future<int> insertWallet(WalletsCompanion wallet) =>
      into(wallets).insert(wallet);

  Future deleteWallet(int id) =>
      (delete(wallets)..where((tbl) => tbl.id.equals(id))).go();

  /// 🔁 Update balance by wallet name
  Future<void> updateBalanceByName(String walletName, double deltaAmount) async {
    final wallet = await (select(wallets)..where((tbl) => tbl.name.equals(walletName)))
        .getSingleOrNull();

    if (wallet != null) {
      final updatedBalance = wallet.balance + deltaAmount;
      await (update(wallets)..where((tbl) => tbl.id.equals(wallet.id)))
          .write(WalletsCompanion(balance: Value(updatedBalance)));
    } else {
      throw Exception("Wallet '$walletName' not found");
    }
  }
}
