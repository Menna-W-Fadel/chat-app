import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:chat_app/core/routes/chat_arguments.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewChatSheet extends StatefulWidget {
  const NewChatSheet();

  @override
  State<NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends State<NewChatSheet> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String _initials(String name) => name
      .trim()
      .split(' ')
      .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
      .take(2)
      .join();

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ── Handle ──
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.sand300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  Text(
                    'New message',
                    style: GoogleFonts.fraunces(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.nearBlack,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.sand100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          size: 16, color: AppColors.warmGrey),
                    ),
                  ),
                ],
              ),
            ),

            // ── Search field ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: _search,
                autofocus: true,
                onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search by name…',
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.midGrey),
                  prefixIcon: const Icon(Icons.search_rounded,
                      size: 18, color: AppColors.midGrey),
                  filled: true,
                  fillColor: AppColors.sand100,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.sand300, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.olive300, width: 1),
                  ),
                ),
              ),
            ),

            Container(height: 0.5, color: AppColors.sand200),

            // ── User list ──
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.olive500,
                        strokeWidth: 2,
                      ),
                    );
                  }

                  final all = snapshot.data!.docs
                      .where((d) => d['uid'] != currentUid)
                      .where((d) {
                    if (_query.isEmpty) return true;
                    final name =
                        (d['name'] as String).toLowerCase();
                    return name.contains(_query);
                  }).toList();

                  if (all.isEmpty) {
                    return Center(
                      child: Text(
                        _query.isEmpty ? 'No users found' : 'No match for "$_query"',
                        style: AppTextStyles.bodySmall,
                      ),
                    );
                  }

                  final avatarColors = [
                    [AppColors.olive100, AppColors.olive600],
                    [AppColors.amber100, AppColors.amber400],
                    [AppColors.sage100, AppColors.sage600],
                    [AppColors.sand200, AppColors.warmGrey],
                  ];

                  return ListView.separated(
                    controller: scrollController,
                    itemCount: all.length,
                    separatorBuilder: (_, __) => Container(
                      height: 0.5,
                      margin: const EdgeInsets.only(left: 72),
                      color: AppColors.sand200,
                    ),
                    itemBuilder: (context, i) {
                      final user = all[i];
                      final name = user['name'] as String;
                      final uid = user['uid'] as String;
                      final colorPair =
                          avatarColors[i % avatarColors.length];

                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            Routes.chatScreen,
                            arguments: ChatArguments(
                              receiverId: uid,
                              receiverName: name,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: colorPair[0],
                                child: Text(
                                  _initials(name),
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: colorPair[1],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(name,
                                    style: AppTextStyles.labelMedium),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  size: 13, color: AppColors.lightGrey),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}