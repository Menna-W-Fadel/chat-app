import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // CURRENT USER
  User? get currentUser => _auth.currentUser;

  // GET USERS STREAM
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore
        .collection('users')
        .snapshots();
  }

  String generateChatRoomId(
    String user1,
    String user2,
  ) {
    List<String> ids = [user1, user2];

    ids.sort();

    return ids.join('_');
  }

  // SEND MESSAGE
  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {

    final String currentUserId =
        currentUser!.uid;

    final Timestamp timestamp =
        Timestamp.now();

    final MessageModel newMessage =
        MessageModel(
      senderId: currentUserId,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // CHAT ROOM ID
    final String chatRoomId =
        generateChatRoomId(
      currentUserId,
      receiverId,
    );

    // CREATE ROOM & SAVE LAST MESSAGE
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .set({
      'participants': [
        currentUserId,
        receiverId,
      ],

      'lastMessage': message,

      'lastMessageTime': timestamp,
    });

    // SAVE MESSAGE
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // GET MESSAGES STREAM
  Stream<QuerySnapshot> getMessages({
    required String userId,
    required String otherUserId,
  }) {

    final String chatRoomId =
        generateChatRoomId(
      userId,
      otherUserId,
    );

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy(
          'timestamp',
          descending: false,
        )
        .snapshots();
  }

  // GET CHAT ROOMS STREAM
Stream<QuerySnapshot> getChatRoomsStream() {
  return _firestore
      .collection('chat_rooms')
      .where('participants', arrayContains: currentUser!.uid)
      .snapshots();
}

// GET OTHER USER ID FROM PARTICIPANTS
String getOtherUserId(List<dynamic> participants) {
  return participants.firstWhere((id) => id != currentUser!.uid);
}
}