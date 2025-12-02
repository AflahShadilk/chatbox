import 'package:chatbox/features/domain/entities/pages/chat_entities.dart';
import 'package:chatbox/features/domain/repository/pages/chat_repository.dart';

class GetUserChatsUsecase {
  final ChatRepository repository;

  const GetUserChatsUsecase(this.repository);
  Future<List<ChatEntities>> call(String userId) =>
      repository.getUserChats(userId);
}
