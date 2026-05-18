import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display / headings — Fraunces (serif, characterful)
  static TextStyle get displayLarge => GoogleFonts.fraunces(
    fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.nearBlack,
  );
  static TextStyle get headingMedium => GoogleFonts.fraunces(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.nearBlack,
  );

  // Body — Plus Jakarta Sans (clean, modern)
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.nearBlack,
  );
  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.nearBlack,
  );
  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.warmGrey,
  );
  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.nearBlack,
  );
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
    fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.midGrey,
  );
  static TextStyle get primaryAction => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.olive500,
  );
  static TextStyle get onPrimary => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.white,
  );
  static TextStyle get errorText => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.error,
  );
  static TextStyle get messageText => GoogleFonts.plusJakartaSans(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.nearBlack,
  );
  static TextStyle get messageTextOnPrimary => GoogleFonts.plusJakartaSans(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.white,
  );
}