import 'package:chatbox/features/domain/repository/pages/chat_repository.dart';

class UpdateUnreadUsecase {
  final ChatRepository repository;
  const UpdateUnreadUsecase(this.repository);
  Future<void> call(String chatId, String userId, int count) =>
      repository.updateUnreadCount(chatId, userId, count);
}
