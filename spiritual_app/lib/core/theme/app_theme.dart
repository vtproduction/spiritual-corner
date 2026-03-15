import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: const ColorScheme.light(
        primary: AppColors.templeRed,
        secondary: AppColors.gold,
        surface: AppColors.ivory,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ivory,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTypography.title,
      ),
      cardTheme: CardThemeData(
        color: AppColors.warmPaper,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.ivory,
        elevation: 0,
        selectedItemColor: AppColors.templeRed,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTypography.caption.copyWith(
          color: AppColors.templeRed,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.caption,
        type: BottomNavigationBarType.fixed,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.p16,
          vertical: AppSpacing.p8,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.hero,
        titleLarge: AppTypography.title,
        titleMedium: AppTypography.section,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.small,
        labelSmall: AppTypography.caption,
      ),
    );
  }
}
