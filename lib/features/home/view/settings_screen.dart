import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/features/home/view/widgets/settings_group.dart';
import 'package:chat_app/features/home/view/widgets/settings_tile.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Sign out?',
          style: GoogleFonts.fraunces(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.nearBlack,
          ),
        ),
        content: Text(
          'You will need to sign in again to access your chats.',
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.midGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Sign out',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await AuthService().logout();

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.loginScreen,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.sand50,
      appBar: AppBar(
        backgroundColor: AppColors.sand50,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Settings',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.nearBlack,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final displayName = data['name'] ?? 'User';

          final email = data['email'] ?? '';

          final initials = displayName
              .trim()
              .split(' ')
              .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
              .take(2)
              .join();

          return ListView(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.sand200, width: 0.5),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.olive100,
                      child: Text(
                        initials,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.olive600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(displayName, style: AppTextStyles.labelMedium),
                          const SizedBox(height: 2),
                          Text(email, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'ACCOUNT',
                  style: AppTextStyles.caption.copyWith(
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SettingsGroup(
                children: [
                  SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Privacy',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'GENERAL',
                  style: AppTextStyles.caption.copyWith(
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SettingsGroup(
                children: [
                  SettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: 'About',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //Logout
              SettingsGroup(
                children: [
                  SettingsTile(
                    icon: Icons.logout_rounded,
                    label: 'Sign out',
                    isDestructive: true,
                    onTap: () => logout(context),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
