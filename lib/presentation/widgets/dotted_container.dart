import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';

class DottedContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double strokeWidth;
  final List<double> dashPattern;
  final Color borderColor;
  final EdgeInsetsGeometry padding;

  const DottedContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.strokeWidth = 1.5,
    this.dashPattern = const [6, 3],
    this.borderColor = const Color(0xFFE3E5E5),
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: borderColor,
      strokeWidth: strokeWidth,
      borderType: BorderType.RRect,
      radius: Radius.circular(borderRadius.r),
      dashPattern: dashPattern,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
