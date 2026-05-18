import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:chat_app/features/chat/view/widgets/date_divider.dart';
import 'package:chat_app/features/chat/view/widgets/input_bar.dart';
import 'package:chat_app/features/chat/view/widgets/message_bubble.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      final hasText = _messageController.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (!_hasText) return;

    await _chatService.sendMessage(
      receiverId: widget.receiverId,
      message: _messageController.text.trim(),
    );

    _messageController.clear();
    scrollDown();
  }

  void scrollDown() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _showDateDivider(List<QueryDocumentSnapshot> messages, int index) {
    if (index == 0) return true;
    final curr = (messages[index]['timestamp'] as Timestamp).toDate();
    final prev = (messages[index - 1]['timestamp'] as Timestamp).toDate();
    return curr.day != prev.day ||
        curr.month != prev.month ||
        curr.year != prev.year;
  }

  String _formatDateDivider(Timestamp ts) {
    final dt = ts.toDate();
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(dt);
  }

  String _initials(String name) {
    return name
        .trim()
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .take(2)
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.sand50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.olive500,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.olive100,
              child: Text(
                _initials(widget.receiverName),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.olive600,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.nearBlack,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: AppColors.sand200),
        ),
      ),
      body: Column(
        children: [
          //Messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessages(
                userId: currentUser!.uid,
                otherUserId: widget.receiverId,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading messages',
                        style: AppTextStyles.bodySmall),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.olive500,
                      strokeWidth: 2,
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.waving_hand_rounded,
                            size: 36, color: AppColors.amber300),
                        const SizedBox(height: 10),
                        Text(
                          'Say hello to ${widget.receiverName}!',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.midGrey),
                        ),
                      ],
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());

                return ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUser.uid;
                    final timestamp = msg['timestamp'] as Timestamp;

                    return Column(
                      children: [
                        // Date divider
                        if (_showDateDivider(messages, index))
                          DateDivider(label: _formatDateDivider(timestamp)),

                        // Message bubble
                        MessageBubble(
                          text: msg['message'],
                          time: DateFormat('hh:mm a').format(timestamp.toDate()),
                          isMe: isMe,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          InputBar(
            controller: _messageController,
            hasText: _hasText,
            onSend: sendMessage,
          ),
        ],
      ),
    );
  }
}