import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Primary Font: Noto Serif (Traditional, Spiritual)
  static TextStyle get _primary => GoogleFonts.notoSerif(
        color: AppColors.textPrimary,
        height: 1.5,
      );

  // Secondary Font: Inter (UI Utility, Dates, Menus)
  static TextStyle get _secondary => GoogleFonts.inter(
        color: AppColors.textPrimary,
        height: 1.3,
      );

  // Text Styles Scale
  static TextStyle get hero => _primary.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get title => _primary.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get section => _primary.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get body => _primary.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get small => _secondary.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => _secondary.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );
}
