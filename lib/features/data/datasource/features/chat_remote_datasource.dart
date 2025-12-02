import 'dart:io';

import 'package:chatbox/features/domain/entities/pages/chat_entities.dart';
import 'package:chatbox/features/domain/entities/pages/message_entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<ChatEntities>> getUserChats(String userId) async {
    final snapShot = await _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    final chats = <ChatEntities>[];
    for (var doc in snapShot.docs) {
      final data = doc.data();
      final participants = List<String>.from(data['participants']);
      final otherUserId = participants.firstWhere((p) => p != userId);
      final messagesQuery = _firestore
          .collection('chats/${doc.id}/messages')
          .orderBy('timestamp', descending: true)
          .limit(1);
      final lastMsgDoc = await messagesQuery.get();
      String? lastMessage;
      DateTime? lastTimestamp;
      if (lastMsgDoc.docs.isNotEmpty &&
          !(lastMsgDoc.docs.first.data()['deleted'] ?? false)) {
        final lastData = lastMsgDoc.docs.first.data();
        lastMessage = lastData['content'];
        lastTimestamp = (lastData['timestamp'] as Timestamp).toDate();
      }
      final unread = data['unread']?[userId] ?? 0;
      chats.add(ChatEntities(
          id: doc.id,
          otherUserId: otherUserId,
          lastMessage: lastMessage,
          lastTimestamp: lastTimestamp,
          otherUserName: data['otherUserName'] ?? 'unknown',
          unreadCount: unread));
    }
    return chats;
  }

  Stream<List<MessageEntities>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats/$chatId/messages')
        .where('deleted', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return MessageEntities(
                id: doc.id,
                chatId: chatId,
                senderId: data['senderId'],
                content: data['content'],
                type: _parseType(data['type']),
                timestamp: (data['timestamp'] as Timestamp).toDate(),
                reactions: Map<String, int>.from(data['reactions'] ?? {}),
                deleted: data['deleted'] ?? false,
              );
            }).toList());
  }

  Future<void>sendMessage(MessageEntities message)async{
    final ref=_firestore.collection('chats/${message.chatId}/messages').doc();
    await ref.set({
      'id':ref.id,
      'senderId':message.senderId,
      'content':message.content,
      'type':_messageTypeToString(message.type),
      'timestamp':Timestamp.fromDate(message.timestamp),
      'reactions':message.reactions,
      'deleted':false,
    });

    //Update chat last message
    await _firestore.collection('chats').doc(message.chatId).update({
     'lastMessage':message.content,
     'lastTimestamp':Timestamp.fromDate(message.timestamp),
    });

    //increment unread for other
    final participantsSnap=await _firestore.collection('chats').doc(message.chatId).get();
    final participants=List<String>.from(participantsSnap.data()!['participants']);
    final otherId= participants.firstWhere((p)=>p!=message.senderId);
    await _firestore.collection('chats').doc(message.chatId).update({
      'unread.$otherId':FieldValue.increment(1),
    });

    //push notification
    final otherToken=await _getUserToken(otherId);
    if(otherToken!=null){
      // Client-side FCM (use Functions for prod); placeholder log
      print('FCM to $otherToken: New ${message.type} from ${message.senderId}');
    }
  }

  Future<void>addReaction(String messageId,String reactionType,String userId,String chatId )async{
    await _firestore.collection('chats/$chatId/messages').doc(messageId).update({
      'reactions.$reactionType':FieldValue.increment(1)
    });
  }
 
 Future<void> deleteMessage(String chatId, String messageId, String userId) async {
    await _firestore.collection('chats/$chatId/messages').doc(messageId).update({'deleted': true});
  }

  Future<void> updateUnreadCount(String chatId, String userId, int count) async {
    await _firestore.collection('chats').doc(chatId).update({'unread.$userId': count});
  }

  Future<String> uploadMedia(String chatId, File file, MessageType type) async {
    String extension = switch (type) {
      MessageType.video => 'mp4',
      MessageType.image => 'jpg',
      MessageType.voice => 'm4a',
      _ => 'txt',
    };
    final ref = _storage.ref().child('chats/$chatId/${DateTime.now().millisecondsSinceEpoch}.$extension');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
  
  Future<String?> _getUserToken(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['fcmToken'];
  }
  String _messageTypeToString(MessageType type) {
    return switch (type) {
      MessageType.image => 'image',
      MessageType.voice => 'voice',
      MessageType.video => 'video',
      _ => 'text',
    };
  }
  MessageType _parseType(String? typeStr) {
    return switch (typeStr) {
      'image' => MessageType.image,
      'voice' => MessageType.voice,
      'video' => MessageType.video,
      _ => MessageType.text,
    };
  }
}
