import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  // TODO: Swap with Figma font family if different
  static TextStyle get h1 => GoogleFonts.urbanist(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get h2 => GoogleFonts.urbanist(
    fontSize: 27.45,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get body => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get label => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle get bottomNavLabel => GoogleFonts.urbanist(
    fontSize: 10.75,
    fontWeight: FontWeight.w500,
    height: 1.11, // Line height: 111%
    color: AppColors.textSecondary, // Default (unselected)
  );

  static TextStyle get navLabelSelected => GoogleFonts.urbanist(
    fontSize: 10.75,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.11, // 111%
  );

  static TextStyle get navLabelUnselected => GoogleFonts.urbanist(
    fontSize: 10.75,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFAEAFB0),
    height: 1.11,
  );

  static TextStyle get monthHeader => GoogleFonts.urbanist(
    fontSize: 18.45,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get topSidebar => GoogleFonts.urbanist(

  fontSize: 15.26,
    fontWeight: FontWeight.w300,
    height: 1.14, // 113.99% line height
    letterSpacing: -0.2652, // -2% of font size
    color: AppColors.textPrimary, // Or your preferred color
  );
  static TextStyle get monthSidebar => GoogleFonts.urbanist(

    fontSize: 14.26,
    fontWeight: FontWeight.w300,
    height: 1.14, // 113.99% line height
    letterSpacing: -0.2652, // -2% of font size
    color: AppColors.textPrimary, // Or your preferred color
  );



}
