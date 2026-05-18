import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message,
) {

  ScaffoldMessenger.of(context)
      .showSnackBar(
   SnackBar(
  content: Text(message, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
  backgroundColor: AppColors.error, 
  behavior: SnackBarBehavior.floating,
  margin: const EdgeInsets.all(12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
)
  );
}