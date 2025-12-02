import 'package:equatable/equatable.dart';

enum MessageType { text, image, voice, video }

class MessageEntities extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final Map<String, int> reactions;
  final bool deleted;

  const MessageEntities(
      {required this.id,
      required this.chatId,
      required this.senderId,
      required this.content,
      required this.type,
      required this.timestamp,
      this.reactions = const {},
      this.deleted = false});

  MessageEntities copyWith({bool? deleted}) => MessageEntities(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      type: type,
      timestamp: timestamp);

  @override
  List<Object?> get props =>
      [id, chatId, senderId, content, type, timestamp, reactions, deleted];
}
