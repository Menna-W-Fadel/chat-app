import 'package:chat_app/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand200, width: 0.5),
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          return Column(
            children: [
              children[i],
              if (i < children.length - 1)
                Container(
                  height: 0.5,
                  margin: const EdgeInsets.only(left: 52),
                  color: AppColors.sand200,
                ),
            ],
          );
        }),
      ),
    );
  }
}