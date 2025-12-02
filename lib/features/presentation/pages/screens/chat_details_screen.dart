import 'dart:io';
import 'package:chatbox/features/domain/entities/pages/chat_entities.dart';
import 'package:chatbox/features/domain/entities/pages/message_entities.dart';
import 'package:chatbox/features/presentation/controller/auth/google_auth_controller.dart';
import 'package:chatbox/features/presentation/controller/pages/chat_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class ChatDetailsScreen extends StatefulWidget {
  final ChatEntities chat;
  const ChatDetailsScreen({super.key, required this.chat});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  final ImagePicker _picker = ImagePicker();
  final ChatDetailController controller = Get.find<ChatDetailController>();
  final GoogleAuthController authController = Get.find<GoogleAuthController>();

  @override
  void initState() {
    super.initState();
    controller.loadMessages(widget.chat.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildMessageList(),
          _buildEmojiPicker(),
          _buildInputBar(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(widget.chat.otherUserName ?? 'Chat'),
      backgroundColor: Colors.deepPurple,
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: Obx(() => ListView.builder(
            reverse: true,
            itemCount: controller.messages.length,
            itemBuilder: (context, index) {
              final message = controller.messages[index];
              final isCurrentUser = message.senderId == authController.currentUser.value?.userId;
              
              return MessageBubble(
                message: message,
                isCurrentUser: isCurrentUser,
                onLongPress: () => _showDeleteDialog(message.id),
                onReact: () => controller.addReaction(message.id, 'like', widget.chat.id),
                player: _player,
                controller: controller,
              );
            },
          )),
    );
  }

  Widget _buildEmojiPicker() {
    return Obx(() => controller.showEmojiPicker.value
        ? SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _messageController.text += emoji.emoji;
                controller.showEmojiPicker.value = false;
                _messageController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _messageController.text.length),
                );
              },
            ),
          )
        : const SizedBox.shrink());
  }

  Widget _buildInputBar() {
    return MessageInputBar(
      messageController: _messageController,
      onSendText: _sendTextMessage,
      onPickImage: _pickImage,
      onPickVideo: _pickVideo,
      onToggleRecording: _toggleRecording,
      onToggleEmoji: () => controller.showEmojiPicker.value = !controller.showEmojiPicker.value,
      isRecording: controller.isRecording,
    );
  }

  void _sendTextMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      controller.sendTextMessage(_messageController.text, widget.chat.id);
      _messageController.clear();
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.sendMediaMessage(
        widget.chat.id,
        File(pickedFile.path),
        MessageType.image,
      );
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.sendMediaMessage(
        widget.chat.id,
        File(pickedFile.path),
        MessageType.video,
      );
    }
  }

  Future<void> _toggleRecording() async {
    if (controller.isRecording.value) {
      final recordingPath = await _recorder.stop();
      if (recordingPath != null) {
        controller.sendMediaMessage(
          widget.chat.id,
          File(recordingPath),
          MessageType.voice,
        );
      }
    } else {
      final tempDirectory = await getTemporaryDirectory();
      final filePath = '${tempDirectory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(const RecordConfig(), path: filePath);
    }
    controller.isRecording.value = !controller.isRecording.value;
  }

  void _showDeleteDialog(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message?'),
        content: const Text('This message will be deleted for everyone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMessage(messageId, widget.chat.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final MessageEntities message;
  final bool isCurrentUser;
  final VoidCallback onLongPress;
  final VoidCallback onReact;
  final AudioPlayer player;
  final ChatDetailController controller;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.onLongPress,
    required this.onReact,
    required this.player,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.deepPurple[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onReact,
                child: MessageContent(
                  message: message,
                  player: player,
                  controller: controller,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.getMessageStatus(message),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageContent extends StatelessWidget {
  final MessageEntities message;
  final AudioPlayer player;
  final ChatDetailController controller;

  const MessageContent({
    super.key,
    required this.message,
    required this.player,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainContent(),
        if (message.reactions.isNotEmpty) _buildReactions(),
      ],
    );
  }

  Widget _buildMainContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(message.content, style: const TextStyle(fontSize: 16));
      
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            message.content,
            height: 200,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        );
      
      case MessageType.voice:
        return VoiceMessagePlayer(
          audioUrl: message.content,
          player: player,
        );
      
      case MessageType.video:
        return VideoMessagePlayer(
          videoUrl: message.content,
          messageId: message.id,
          controller: controller,
        );
    }
  }

  Widget _buildReactions() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        children: [
          const Icon(Icons.thumb_up, size: 16, color: Colors.blue),
          Text(
            '${message.reactions['like'] ?? 0}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class VoiceMessagePlayer extends StatelessWidget {
  final String audioUrl;
  final AudioPlayer player;

  const VoiceMessagePlayer({
    super.key,
    required this.audioUrl,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => player.play(UrlSource(audioUrl)),
        ),
        const Text('Voice message', style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

class VideoMessagePlayer extends StatelessWidget {
  final String videoUrl;
  final String messageId;
  final ChatDetailController controller;

  const VideoMessagePlayer({
    super.key,
    required this.videoUrl,
    required this.messageId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final videoController = controller.initializeVideo(videoUrl, messageId);
    
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoPlayer(videoController),
        ),
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => videoController.play(),
        ),
      ],
    );
  }
}

class MessageInputBar extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendText;
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;
  final VoidCallback onToggleRecording;
  final VoidCallback onToggleEmoji;
  final RxBool isRecording;

  const MessageInputBar({
    super.key,
    required this.messageController,
    required this.onSendText,
    required this.onPickImage,
    required this.onPickVideo,
    required this.onToggleRecording,
    required this.onToggleEmoji,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image, color: Colors.deepPurple),
            onPressed: onPickImage,
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.deepPurple),
            onPressed: onPickVideo,
          ),
          Obx(() => IconButton(
                icon: Icon(
                  isRecording.value ? Icons.stop : Icons.mic,
                  color: isRecording.value ? Colors.red : Colors.deepPurple,
                ),
                onPressed: onToggleRecording,
              )),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => onSendText(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions, color: Colors.deepPurple),
            onPressed: onToggleEmoji,
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.deepPurple),
            onPressed: onSendText,
          ),
        ],
      ),
    );
  }
}