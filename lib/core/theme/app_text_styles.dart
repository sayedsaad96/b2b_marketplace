import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Typography scale using flutter_screenutil .sp units.
class AppTextStyles {
  AppTextStyles._();

  // ── Headings ──
  static TextStyle headlineLarge = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle headlineMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle headlineSmall = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ── Title ──
  static TextStyle titleLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ── Body ──
  static TextStyle bodyLarge = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ── Caption ──
  static TextStyle caption = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.4,
  );

  // ── Button ──
  static TextStyle button = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );
}
