import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_bloc.dart';
import 'package:expense_tracker_clean/application/blocs/transaction_list/transaction_list_event.dart';
import 'package:expense_tracker_clean/core/di/di.dart';
import 'package:expense_tracker_clean/data/datasources/local/app_database.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/transaction_dao.dart';
import 'package:expense_tracker_clean/data/datasources/local/dao/wallet/wallet_dao.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/transactions/widgets/transaction_attachment_section.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/transactions/widgets/transaction_description_section.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/transactions/widgets/transaction_detail_header.dart';
import 'package:expense_tracker_clean/presentation/screens/dashboard/modules/transactions/widgets/transaction_info_card.dart';
import 'package:expense_tracker_clean/presentation/widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            TransactionDetailHeader(
              transaction: transaction,
              onDelete: () async {
                context
                    .read<TransactionListBloc>()
                    .add(DeleteTransaction(transaction: transaction));
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),

            // Content section
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).padding.top + 300.h),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction info card
                    TransactionInfoCard(transaction: transaction),
                    SizedBox(height: 24.h),
                    // Description section
                    TransactionDescriptionSection(
                      description: transaction.description,
                    ),
                    SizedBox(height: 24.h),

                    // Attachment section
                    TransactionAttachmentSection(
                      attachmentPath: transaction.attachment,
                    ),

                    // Spacer
                    SizedBox(height: 40.h),

                    // Edit button
                    FormButton(
                      label: 'Edit',
                      isEnabled: true,
                      isLoading: false,
                      onPressed: () {
                        // Handle edit action
                      },
                    ),

                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
