import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const SettingsTile({super.key, 
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.nearBlack;
    final iconBg = isDestructive
        ? const Color(0xFFFCEBEB)
        : AppColors.olive50;
    final iconColor =
        isDestructive ? AppColors.error : AppColors.olive500;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 17, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: AppTextStyles.bodyMedium.copyWith(color: color)),
            ),
            if (!isDestructive)
              const Icon(Icons.chevron_right_rounded,
                  size: 18, color: AppColors.lightGrey),
          ],
        ),
      ),
    );
  }
}