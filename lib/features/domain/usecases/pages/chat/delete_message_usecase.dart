import 'package:chatbox/features/domain/repository/pages/chat_repository.dart';

class DeleteMessageUsecase {
  final ChatRepository repository;
  const DeleteMessageUsecase(this.repository);
  Future<void>call(String chatId,String messageId,String userId)=>repository.deleteMessage(chatId, messageId, userId);
}