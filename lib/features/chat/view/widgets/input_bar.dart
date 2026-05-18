
import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

class InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSend;

  const InputBar({super.key, 
    required this.controller,
    required this.hasText,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.sand200, width: 0.5)),
      ),
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text field
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: TextField(
                controller: controller,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: AppTextStyles.messageText,
                decoration: InputDecoration(
                  hintText: 'Message…',
                  hintStyle: AppTextStyles.messageText
                      .copyWith(color: AppColors.midGrey),
                  filled: true,
                  fillColor: AppColors.sand100,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(
                        color: AppColors.sand300, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(
                        color: AppColors.olive300, width: 1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: hasText ? AppColors.olive500 : AppColors.sand200,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: hasText ? onSend : null,
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.send_rounded,
                size: 18,
                color: hasText ? AppColors.white : AppColors.lightGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}