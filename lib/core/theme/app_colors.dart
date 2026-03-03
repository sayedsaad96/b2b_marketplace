import 'package:flutter/material.dart';

/// App color palette for both light and dark themes.
class AppColors {
  AppColors._();

  // ── Primary ──
  static const Color primary = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF534BAE);
  static const Color primaryDark = Color(0xFF000051);
  static const Color onPrimary = Colors.white;

  // ── Secondary ──
  static const Color secondary = Color(0xFFFF6F00);
  static const Color secondaryLight = Color(0xFFFFA040);
  static const Color secondaryDark = Color(0xFFC43E00);
  static const Color onSecondary = Colors.white;

  // ── Surface / Background ──
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // ── Text ──
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);

  // ── Status ──
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // ── Misc ──
  static const Color divider = Color(0xFFBDBDBD);
  static const Color disabled = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  // ── Aliases ──
  static const Color surface = surfaceLight;
  static const Color background = backgroundLight;
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textTertiary = textSecondaryLight;
}
