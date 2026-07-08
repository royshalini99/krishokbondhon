import 'package:flutter/material.dart';

/// Central color palette for KrishokBondhon.
/// Theme: warm, bright, earthy-yet-vivid — greens for growth/agriculture,
/// sunny amber/orange for energy & optimism, with clean neutrals.
class AppColors {
  AppColors._();

  // Brand
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenLight = Color(0xFF60AD5E);
  static const Color primaryGreenDark = Color(0xFF005005);

  static const Color accentAmber = Color(0xFFFFA726);
  static const Color accentAmberLight = Color(0xFFFFD95B);
  static const Color accentAmberDark = Color(0xFFC77800);

  static const Color skyBlue = Color(0xFF29B6F6);
  static const Color earthBrown = Color(0xFF8D6E63);

  // Semantic
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);
  static const Color danger = Color(0xFFE53935);
  static const Color info = Color(0xFF29B6F6);

  // Disease severity scale
  static const Color severityHealthy = Color(0xFF43A047);
  static const Color severityMild = Color(0xFFFDD835);
  static const Color severityModerate = Color(0xFFFB8C00);
  static const Color severitySevere = Color(0xFFE53935);

  // Neutrals
  static const Color background = Color(0xFFF7FAF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0F4EC);
  static const Color textPrimary = Color(0xFF1B2A1E);
  static const Color textSecondary = Color(0xFF5B6B5E);
  static const Color divider = Color(0xFFE1E8DC);

  // Gradients
  static const List<Color> heroGradient = [
    Color(0xFF2E7D32),
    Color(0xFF66BB6A),
  ];

  static const List<Color> sunriseGradient = [
    Color(0xFFFFA726),
    Color(0xFFFFD95B),
  ];

  static const List<Color> skyGradient = [
    Color(0xFF29B6F6),
    Color(0xFF81D4FA),
  ];
}
