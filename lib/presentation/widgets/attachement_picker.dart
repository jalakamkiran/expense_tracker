import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker_clean/core/res/app_colors.dart';
import 'package:expense_tracker_clean/core/res/app_text_styles.dart';
import 'package:path/path.dart' as path;

class AttachmentPicker extends StatelessWidget {
  final PlatformFile? selectedFile;
  final void Function(PlatformFile?) onFilePicked;

  const AttachmentPicker({
    super.key,
    required this.selectedFile,
    required this.onFilePicked,
  });

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      onFilePicked(result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickFile(context),
      child: selectedFile == null
          ? DottedBorder(
        color: AppColors.baseLight20,
        dashPattern: const [6, 3],
        borderType: BorderType.RRect,
        radius: Radius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.h),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.attach_file, color: AppColors.baseLight20),
              SizedBox(width: 8.w),
              Text(
                "Add attachment",
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.baseLight20,
                ),
              ),
            ],
          ),
        ),
      )
          : _buildFilePreview(selectedFile!),
    );
  }

  Widget _buildFilePreview(PlatformFile file) {
    final isImage = ['.png', '.jpg', '.jpeg'].contains(path.extension(file.name).toLowerCase());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: AppColors.violet20.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                File(file.path!),
                width: 48.w,
                height: 48.w,
                fit: BoxFit.cover,
              ),
            )
          else
            const Icon(Icons.insert_drive_file, color: AppColors.violet100, size: 40),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              file.name,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body1,
            ),
          ),
          IconButton(
            icon:  const Icon(Icons.close, color: AppColors.baseLight20),
            onPressed: () => onFilePicked(null),
          ),
        ],
      ),
    );
  }
}
