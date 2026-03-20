import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData lightTheme(Color seedColor) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
        surface: AppColors.ivory,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ivory,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTypography.title.copyWith(color: AppColors.textPrimary),
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
        selectedItemColor: seedColor,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTypography.caption.copyWith(
          color: seedColor,
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
        displayLarge: AppTypography.hero.copyWith(color: AppColors.textPrimary),
        titleLarge: AppTypography.title.copyWith(color: AppColors.textPrimary),
        titleMedium: AppTypography.section.copyWith(color: AppColors.textPrimary),
        bodyLarge: AppTypography.body.copyWith(color: AppColors.textPrimary),
        bodyMedium: AppTypography.small.copyWith(color: AppColors.textPrimary),
        labelSmall: AppTypography.caption.copyWith(color: AppColors.textSecondary),
      ),
    );
  }

  static ThemeData darkTheme(Color seedColor) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E1E),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.warmPaper),
        titleTextStyle: AppTypography.title.copyWith(color: AppColors.warmPaper),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        selectedItemColor: seedColor,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTypography.caption.copyWith(
          color: seedColor,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        type: BottomNavigationBarType.fixed,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.p16,
          vertical: AppSpacing.p8,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.hero.copyWith(color: AppColors.warmPaper),
        titleLarge: AppTypography.title.copyWith(color: AppColors.warmPaper),
        titleMedium: AppTypography.section.copyWith(color: AppColors.warmPaper),
        bodyLarge: AppTypography.body.copyWith(color: AppColors.warmPaper),
        bodyMedium: AppTypography.small.copyWith(color: AppColors.warmPaper),
        labelSmall: AppTypography.caption.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
