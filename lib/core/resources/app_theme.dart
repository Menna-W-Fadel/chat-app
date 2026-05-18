import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.sand50,
    colorScheme: const ColorScheme.light(
      primary: AppColors.olive500,
      onPrimary: AppColors.white,
      secondary: AppColors.amber400,
      surface: AppColors.white,
      error: AppColors.error,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.nearBlack,
      elevation: 0,
      titleTextStyle: GoogleFonts.fraunces(
        fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.nearBlack,
      ),
      iconTheme: const IconThemeData(color: AppColors.olive500),
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.sand200,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.olive500,
      unselectedItemColor: AppColors.midGrey,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.sand200, thickness: 0.5, space: 0,
    ),
  );
}