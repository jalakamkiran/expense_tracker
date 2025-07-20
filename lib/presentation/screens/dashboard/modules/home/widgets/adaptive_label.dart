import 'package:flutter/material.dart';

class AdaptiveLabel extends StatelessWidget {
  final Color backgroundColor;
  final IconData iconData;
  final String title;
  final double? fontSize;
  final double? iconSize;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const AdaptiveLabel({
    Key? key,
    required this.backgroundColor,
    required this.iconData,
    required this.title,
    this.fontSize = 12,
    this.iconSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final luminance = backgroundColor.computeLuminance();

    final foregroundColor = luminance > 0.5 ? Colors.black87 : Colors.white;

    final borderColor = luminance > 0.5
        ? Colors.black.withOpacity(0.1)
        : Colors.white.withOpacity(0.2);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(
          color: borderColor,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(
          //   iconData,
          //   size: iconSize,
          //   color: foregroundColor,
          // ),
          // const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: foregroundColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}