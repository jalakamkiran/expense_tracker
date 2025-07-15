import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/core/routes/routes.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/wallet/wallet_dao.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnWallets();
  }

  Future<void> _navigateBasedOnWallets() async {
    final db = sl<AppDatabase>();
    final wallets = await WalletDao(db).getAllWallets();

    await Future.delayed(const Duration(milliseconds: 1200)); // Optional delay for effect

    if (!mounted) return;

    if (wallets.isEmpty) {
      Navigator.pushReplacementNamed(context, AppRoutes.newAccount);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(), // You can replace with logo/animation
      ),
    );
  }
}
