import 'package:expense_tracker_clean/application/blocs/add_transaction/add_transaction_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/bottom_nav_bar/bottom_nav_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/home/home_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/home/home_event.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/wallet/wallet_bloc.dart';
import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_clean/presentation/screens/add_transaction/add_transaction_screen.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/transactions/widgets/transaction_details.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/widgets/lock_screen.dart';
import 'package:expense_tracker_clean/presentation/screens/new_account/setup_account.dart';
import 'package:expense_tracker_clean/presentation/screens/splash_screen/splash_screen.dart';
import 'package:expense_tracker_clean/presentation/screens/wallet/create_new_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String addTransaction = '/addTransaction';
  static const String newAccount = '/newAccount';
  static const String newWallet = '/newWallet';
  static const String transactionDetails = '/transactionDetails';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<HomeBloc>()..add(LoadHomeData())),
              BlocProvider(create: (_) => sl<BottomNavBloc>()),
              BlocProvider(create: (_) => sl<TransactionListBloc>()),
            ],
            child: const LockScreen(child: DashboardScreen()),
          ),
        );

      case addTransaction:
        final TransactionType type =
            (settings.arguments as TransactionType?) ?? TransactionType.expense;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AddTransactionBloc>(),
            child: AddTransactionScreen(type: type),
          ),
        );

      case transactionDetails:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<TransactionListBloc>(),
            child: TransactionDetailScreen(
              transaction: settings.arguments! as Transaction,
            ),
          ),
        );

      case newAccount:
        return MaterialPageRoute(builder: (_) => const SetupAccountScreen());

      case newWallet:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<WalletBloc>(),
            child: const CreateNewWalletScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
