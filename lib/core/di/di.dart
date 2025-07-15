import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/bottom_nav_bar/bottom_nav_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/home/home_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/wallet/wallet_bloc.dart';
import 'package:expense_tracker_clean/core/services/auth_service.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // sl = service locator


Future<void> init() async {
  final db = AppDatabase();
  sl.registerFactory(() => AddTransactionBloc());
  sl.registerFactory(() => WalletBloc());
  sl.registerFactory(() => HomeBloc());
  sl.registerFactory(() => BottomNavBloc());
  sl.registerFactory(() => TransactionListBloc());
  sl.registerLazySingleton(() => AuthService());

  sl.registerLazySingleton<AppDatabase>(() => db);
}
