import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

class DateDivider extends StatelessWidget {
  final String label;
  const DateDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(child: Container(height: 0.5, color: AppColors.sand300)),
          const SizedBox(width: 10),
          Text(label, style: AppTextStyles.caption),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 0.5, color: AppColors.sand300)),
        ],
      ),
    );
  }
}