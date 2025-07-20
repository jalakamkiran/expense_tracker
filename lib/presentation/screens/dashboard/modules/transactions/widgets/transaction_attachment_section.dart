import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionAttachmentSection extends StatelessWidget {
  final String? attachmentPath;

  const TransactionAttachmentSection({
    super.key,
    this.attachmentPath,
  });

  @override
  Widget build(BuildContext context) {
    if (attachmentPath == null || attachmentPath!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachment',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 12.h),
        _AttachmentWidget(attachmentPath: attachmentPath!),
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _AttachmentWidget extends StatelessWidget {
  final String attachmentPath;

  const _AttachmentWidget({
    required this.attachmentPath,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(attachmentPath);

    if (!file.existsSync()) {
      return SizedBox(height: 116.h);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 116.h,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Icon(
                Icons.broken_image,
                color: Colors.grey.shade400,
                size: 32.sp,
              ),
            );
          },
        ),
      ),
    );
  }
}