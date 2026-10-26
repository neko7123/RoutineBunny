import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData forName(String name) {
    final seed = switch (name) {
      'Soft Lavender' => const Color(0xFFB99BE8),
      'Warm Peach' => const Color(0xFFF3A27C),
      _ => AppColors.strawberryPink,
    };
    return _build(seed);
  }

  static ThemeData get light {
    return _build(AppColors.strawberryPink);
  }

  static ThemeData _build(Color seed) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      surface: AppColors.cream,
    );
    return ThemeData(
      colorScheme: scheme.copyWith(
        primary: AppColors.strawberryPink,
        onPrimary: AppColors.softWhite,
        surface: AppColors.cream,
        onSurface: AppColors.cocoaBrown,
      ),
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'sans-serif',
      useMaterial3: true,
      cardTheme: CardThemeData(
        color: AppColors.softWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.softWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.borderPink),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.borderPink),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.rosePink, width: 2),
        ),
      ),
    );
  }
}
