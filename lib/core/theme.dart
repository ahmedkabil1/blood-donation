import 'package:flutter/material.dart';

/// Colors sampled from the Figma designs (red & white identity).
class AppColors {
  AppColors._();

  static const maroon = Color(0xFF800000); // buttons / active items
  static const crimson = Color(0xFFB30F1B); // headings, accents
  static const deep = Color(0xFF6B0610); // dark gradient start
  static const heroEnd = Color(0xFFB30F1B);
  static const pink = Color(0xFFFFE4E4);
  static const pinkStrong = Color(0xFFFAB8BD);
  static const background = Color(0xFFF2F2F4);
  static const field = Color(0xFFF1F1F1);
  static const border = Color(0xFFD9D9D9);
  static const cardGrey = Color(0xFFD9D9D9);
  static const authCard = Color(0xFFE6E5E4);
  static const text = Color(0xFF111111);
  static const muted = Color(0xFF6E6E6E);
  static const success = Color(0xFF1FA84F);
  static const amberChip = Color(0xFFE8D8B8);
  static const shadow = Color(0x14000000);
}

class AppTheme {
  AppTheme._();

  /// Falls back silently to the platform font if Cairo is not bundled.
  static const fontFamily = 'Cairo';

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.maroon,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.maroon,
      secondary: AppColors.crimson,
      error: AppColors.crimson,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: AppColors.text, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
    );
  }
}
