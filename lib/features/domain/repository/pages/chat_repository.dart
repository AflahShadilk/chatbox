import 'package:chatbox/features/domain/entities/pages/chat_entities.dart';
import 'package:chatbox/features/domain/entities/pages/message_entities.dart';

abstract class ChatRepository {
  Future<List<ChatEntities>> getUserChats(String userId);
  Stream<List<MessageEntities>> getChatMessages(String chatId);
  Future<void> sendMessage(MessageEntities message);
  Future<void> addReaction(
      String messageId, String reactionType, String userId, String chatId);
  Future<void> deleteMessage(String chatId, String messageId, String userId);
  Future<void> updateUnreadCount(String chatId, String userId, int count);
}
