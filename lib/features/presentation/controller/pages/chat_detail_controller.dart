import 'dart:io';
import 'package:chatbox/core/message/snack_bar_handler.dart';
import 'package:chatbox/features/data/datasource/features/chat_remote_datasource.dart';
import 'package:chatbox/features/data/repository/features/chat_repository_imple.dart';
import 'package:chatbox/features/domain/entities/pages/message_entities.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/delete_message_usecase.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/get_chat_messages_usecase.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/send_message_usecase.dart';
import 'package:chatbox/features/presentation/controller/auth/google_auth_controller.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ChatDetailController extends GetxController {
  final SendMessageUsecase sendMessageUsecase;
  final GetChatMessagesUsecase getChatMessagesUsecase;
  final DeleteMessageUsecase deleteMessageUsecase;
  final GoogleAuthController authController = Get.find();
  final ChatRemoteDatasource datasource = Get.find();

  final RxList<MessageEntities> messages = <MessageEntities>[].obs;
  final RxBool showEmojiPicker = false.obs;
  final RxBool isRecording = false.obs;
  final Map<String, VideoPlayerController> videoControllers = {};

  ChatDetailController(
    this.sendMessageUsecase,
    this.getChatMessagesUsecase,
    this.deleteMessageUsecase,
  );

  String get currentUserId => authController.currentUser.value?.userId ?? '';

  void loadMessages(String chatId) {
    getChatMessagesUsecase.call(chatId).listen((messageList) {
      messages.assignAll(messageList);
    });
  }

  Future<void> sendTextMessage(String text, String chatId) async {
    if (text.trim().isEmpty) return;

    final message = MessageEntities(
      id: '',
      chatId: chatId,
      senderId: currentUserId,
      content: text,
      type: MessageType.text,
      timestamp: DateTime.now(),
    );

    await sendMessageUsecase.call(message);
    SnackBarHelper.success('Message sent!');
  }

  Future<void> sendMediaMessage(String chatId, File file, MessageType type) async {
    try {
      final mediaUrl = await datasource.uploadMedia(chatId, file, type);
      
      final message = MessageEntities(
        id: '',
        chatId: chatId,
        senderId: currentUserId,
        content: mediaUrl,
        type: type,
        timestamp: DateTime.now(),
      );

      await sendMessageUsecase.call(message);
      SnackBarHelper.success('Media sent successfully!');
    } catch (error) {
      SnackBarHelper.error('Upload failed: ${error.toString()}');
    }
  }

  Future<void> addReaction(String messageId, String reaction, String chatId) async {
    try {
      final repository = Get.find<ChatRepositoryImple>();
      await repository.addReaction(messageId, reaction, currentUserId, chatId);
      messages.refresh();
    } catch (error) {
      SnackBarHelper.error('Failed to add reaction');
    }
  }

  Future<void> deleteMessage(String messageId, String chatId) async {
    try {
      await deleteMessageUsecase.call(chatId, messageId, currentUserId);
      messages.refresh();
      SnackBarHelper.success('Message deleted');
    } catch (error) {
      SnackBarHelper.error('Failed to delete message');
    }
  }

  String getMessageStatus(MessageEntities message) {
    return message.deleted ? 'Deleted' : 'Delivered';
  }

  VideoPlayerController initializeVideo(String videoUrl, String messageId) {
    if (videoControllers.containsKey(messageId)) {
      return videoControllers[messageId]!;
    }

    final videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    
    videoController.initialize().then((_) {
      videoController.setLooping(false);
    });

    videoControllers[messageId] = videoController;
    return videoController;
  }

  @override
  void onClose() {
    for (var videoController in videoControllers.values) {
      videoController.dispose();
    }
    videoControllers.clear();
    super.onClose();
  }
}