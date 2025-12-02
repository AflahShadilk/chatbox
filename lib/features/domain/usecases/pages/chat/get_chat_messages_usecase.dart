import 'package:chatbox/features/domain/entities/pages/message_entities.dart';
import 'package:chatbox/features/domain/repository/pages/chat_repository.dart';

class GetChatMessagesUsecase {
  final ChatRepository repository;
  const GetChatMessagesUsecase(this.repository);
  Stream<List<MessageEntities>> call(String chatId) =>
      repository.getChatMessages(chatId);
}
