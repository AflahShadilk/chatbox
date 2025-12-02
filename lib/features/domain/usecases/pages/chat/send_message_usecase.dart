import 'package:chatbox/features/domain/entities/pages/message_entities.dart';
import 'package:chatbox/features/domain/repository/pages/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository repository;
  const SendMessageUsecase(this.repository);
  Future<void> call(MessageEntities message) => repository.sendMessage(message);
}
