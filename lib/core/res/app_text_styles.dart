import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final heading = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static final amount = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
  );

  static final label = TextStyle(
    fontSize: 14.sp,
    color: Colors.grey,
  );

  static final label2 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
  );

  static final title3 = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 18.sp,
  );

  static final heading2 = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 36.sp,
  );

  static final title2 = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
  );

  static final textFieldTextStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 18.h/16.sp
  );

  static final title1 = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 64.sp,
  );

  static final body1 = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
  );

  static final body3 = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 18.h/14.sp
  );

  static final small = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
    height: 16.h/13.sp
  );
}
