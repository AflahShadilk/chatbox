import 'package:chatbox/core/constant/appcolors/app_colors.dart';
import 'package:chatbox/features/presentation/controller/auth/google_auth_controller.dart';
import 'package:chatbox/features/presentation/controller/pages/chat_controller.dart';
import 'package:chatbox/features/presentation/pages/widgets/header_container_reusable.dart';
import 'package:chatbox/features/presentation/pages/widgets/reusable_curved_container.dart';
import 'package:chatbox/features/presentation/pages/widgets/textstyles/reusable_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ChatController>().loadChats();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<GoogleAuthController>();
    final chatController = Get.find<ChatController>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (chatController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              HeaderContainer(
                backgroundColor: AppColors.black,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    ChatTopBar(
                      title: 'Chats',
                      onSearchPressed: () {}, // Add later
                      onProfilePressed: () => authController.signOut(),
                    ),
                  ],
                ),
              ),
              CurvedContainer(
                topPosition: screenHeight * 0.3 - 30,
                backgroundColor: AppColors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: chatController.errorMsg.value.isNotEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(chatController.errorMsg.value),
                                  ElevatedButton(
                                    onPressed: chatController.refreshChats,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : chatController.chats.isEmpty
                              ? const Center(child: Text('No chats yet! Start one.'))
                              : ListView.builder(
                                  itemCount: chatController.chats.length,
                                  itemBuilder: (context, index) {
                                    final chat = chatController.chats[index];
                                    return ListTile(
                                      leading: CircleAvatar(child: Text(chat.otherUserName?[0] ?? '?')),
                                      title: Text(chat.otherUserName ?? 'Unknown'),
                                      subtitle: Text(chat.lastMessage ?? 'No messages'),
                                      trailing: chat.lastTimestamp != null
                                          ? Text(_formatTime(chat.lastTimestamp!))
                                          : null,
                                      onTap: () => chatController.openChat(chat),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays > 0) return '${time.day}/${time.month}';
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}