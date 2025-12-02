import 'package:chatbox/core/message/snack_bar_handler.dart';
import 'package:chatbox/features/domain/entities/pages/chat_entities.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/get_user_chats_usecase.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/update_unread_usecase.dart';
import 'package:chatbox/features/presentation/controller/auth/google_auth_controller.dart';
import 'package:chatbox/features/presentation/pages/screens/chat_details_screen.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  final GetUserChatsUsecase getUserChatsUsecase;
  final UpdateUnreadUsecase updateUnreadUsecase;
  final GoogleAuthController authController=Get.find();

  final RxList<ChatEntities>chats=<ChatEntities>[].obs;
  final isLoading = false.obs;
  final errorMsg = ''.obs;

  ChatController(this.getUserChatsUsecase,this.updateUnreadUsecase);
 
 @override
  void onInit() {
  
    super.onInit();
    loadChats();
  }

   Future<void>loadChats()async{
    if(authController.currentUser.value?.userId==null)return;
    isLoading.value=true;
    errorMsg.value='';
    try{
      final userChats=await getUserChatsUsecase.call(authController.currentUser.value!.userId);
      chats.assignAll(userChats);
    } catch (e){
      SnackBarHelper.error('Failed to load chats: $e');
    }finally{
      isLoading.value=false;
    }

   }

   void openChat(ChatEntities chat){
    Get.to(()=>ChatDetailsScreen(chat:chat));
    updateUnreadUsecase.call(chat.id,authController.currentUser.value!.userId, 0);
   }
  void refreshChats()=>loadChats();
}