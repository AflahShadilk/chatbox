import 'package:chatbox/features/data/datasource/features/chat_remote_datasource.dart';
import 'package:chatbox/features/domain/entities/pages/chat_entities.dart';
import 'package:chatbox/features/domain/entities/pages/message_entities.dart';
import 'package:chatbox/features/domain/repository/pages/chat_repository.dart';

class ChatRepositoryImple implements ChatRepository {
  final ChatRemoteDatasource datasource;
  const ChatRepositoryImple({required this.datasource});

  @override
  Future<List<ChatEntities>> getUserChats(String userId) =>
      datasource.getUserChats(userId);

  @override
  Stream<List<MessageEntities>> getChatMessages(String chatId) =>
      datasource.getChatMessages(chatId);

  @override
  Future<void> sendMessage(MessageEntities message) =>
      datasource.sendMessage(message);

  @override
  Future<void> addReaction(String messageId, String reactionType, String userId,
          String chatId) =>
      datasource.addReaction(messageId, reactionType, userId, chatId);

  @override
  Future<void> deleteMessage(String chatId, String messageId, String userId) =>
      datasource.deleteMessage(chatId, messageId, userId);

  @override
  Future<void> updateUnreadCount(String chatId, String userId, int count) =>
      datasource.updateUnreadCount(chatId, userId, count);
}
