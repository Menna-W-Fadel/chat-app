import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:chat_app/core/routes/chat_arguments.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/features/home/view/widgets/new_chat_sheet.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatTime(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate();
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return DateFormat('hh:mm a').format(dt);
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return DateFormat('EEE').format(dt);
    return DateFormat('MM/dd').format(dt);
  }

  void _showNewChatSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NewChatSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomService = ChatService();

    return Scaffold(
      backgroundColor: AppColors.sand50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Chats',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.nearBlack,
          ),
        ),
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: AppColors.sand200),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChatSheet(context),
        backgroundColor: AppColors.olive500,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.white,
          size: 22,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatRoomService.getChatRoomsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: AppTextStyles.bodyMedium,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.olive500,
                strokeWidth: 2,
              ),
            );
          }

          final rooms = snapshot.data!.docs;

          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/icons/conversation.json",
                    width: 150,
                    height: 150,
                  ),
                  Text(
                    'No conversations yet',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.midGrey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: rooms.length,
            separatorBuilder: (_, __) => Container(
              height: 0.5,
              margin: const EdgeInsets.only(left: 76),
              color: AppColors.sand200,
            ),
            itemBuilder: (context, index) {
              final room = rooms[index];
              final data = room.data() as Map<String, dynamic>;
              final participants = List<String>.from(
                data['participants'] ?? [],
              );
              final otherUserId = chatRoomService.getOtherUserId(participants);
              final lastMessage = data['lastMessage'] as String? ?? '';
              final lastTime = data['lastMessageTime'] as Timestamp?;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnap) {
                  final userName = userSnap.data?.get('name') as String? ?? '…';
                  final initials = userName.isNotEmpty
                      ? userName
                            .trim()
                            .split(' ')
                            .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
                            .take(2)
                            .join()
                      : '?';

                  // Rotate avatar colors per index
                  final avatarColors = [
                    [AppColors.olive100, AppColors.olive600],
                    [AppColors.amber100, AppColors.amber400],
                    [AppColors.sage100, AppColors.sage600],
                    [AppColors.sand200, AppColors.warmGrey],
                  ];
                  final colorPair = avatarColors[index % avatarColors.length];

                  return InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.chatScreen,
                      arguments: ChatArguments(
                        receiverId: otherUserId,
                        receiverName: userName,
                      ),
                    ),
                    child: Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: colorPair[0],
                            child: Text(
                              initials,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: colorPair[1],
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Name + last message
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: AppTextStyles.labelMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  lastMessage.isEmpty
                                      ? 'No messages yet'
                                      : lastMessage,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: lastMessage.isEmpty
                                        ? AppColors.lightGrey
                                        : AppColors.warmGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Timestamp
                          Text(
                            _formatTime(lastTime),
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
