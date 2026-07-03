import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// AeroVista typography scale.
/// All styles use the Inter font via google_fonts.
class AppTextStyles {
  AppTextStyles._();

  /// Hero / large display text — used for city names, key numbers.
  static TextStyle get display => GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  /// Section / screen titles.
  static TextStyle get title => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  /// Card headings and sub-section labels.
  static TextStyle get subtitle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Regular body copy.
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Small supporting text, disclaimers, labels.
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );
}
