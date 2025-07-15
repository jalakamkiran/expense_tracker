import 'package:expense_tracker_clean/application/blocs/home/home_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/home/home_event.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/routes/routes.dart';
import 'package:expense_tracker_clean/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomFABBar extends StatelessWidget {
  const CustomFABBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: AppColors.violet100,
      foregroundColor: Colors.white,
      overlayOpacity: 0.3,
      spacing: 16,
      spaceBetweenChildren: 12,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.arrow_downward, color: Colors.white),
          backgroundColor: const Color(0xFF27AE60),
          label: 'Add Income',
          labelStyle: const TextStyle(color: Colors.black),
          onTap: () async {
            await Navigator.pushNamed(context, AppRoutes.addTransaction,
                arguments: TransactionType.income).then((_){
              context.read<HomeBloc>().add(LoadHomeData());
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.arrow_upward, color: Colors.white),
          backgroundColor: const Color(0xFFEB5757),
          label: 'Add Expense',
          labelStyle: const TextStyle(color: Colors.black),
          onTap: () async {
            await Navigator.pushNamed(context, AppRoutes.addTransaction,
                arguments: TransactionType.expense).then((_){
              context.read<HomeBloc>().add(LoadHomeData());
            });
          },
        ),
      ],
    );
  }
}
