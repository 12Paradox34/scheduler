import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  static final light = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: true,
    textTheme: TextTheme(
      headlineSmall: AppTypography.h1,
      bodyMedium: AppTypography.body,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.background,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      titleTextStyle: AppTypography.h1,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),


    /// this block is to control BottomNavigationBar appearance
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
  backgroundColor: AppColors.background,
  selectedItemColor: AppColors.primary,
  unselectedItemColor: const Color(0xFFAEAFB0), // from Figma
  selectedLabelStyle: AppTypography.bottomNavLabel.copyWith(
  color: AppColors.primary,
  ),
  unselectedLabelStyle: AppTypography.bottomNavLabel.copyWith(
  color: const Color(0xFFAEAFB0),
  ),
  elevation: 0,
  type: BottomNavigationBarType.fixed,
  ))
  ;


}
