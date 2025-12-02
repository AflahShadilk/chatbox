import 'package:equatable/equatable.dart';

class ChatEntities extends Equatable {
  final String id;
  final String otherUserId;
  final String? lastMessage;
  final DateTime? lastTimestamp;
  final String? otherUserName;
  final int unreadCount;

  const ChatEntities(
      {required this.id,
      required this.otherUserId,
      this.lastMessage,
      this.lastTimestamp,
      this.otherUserName,
      this.unreadCount = 0});

  @override
  List<Object?> get props =>
      [id, otherUserId, lastMessage, lastTimestamp, otherUserName, unreadCount];
}
