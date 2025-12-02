import 'package:chatbox/features/data/datasource/auth/google_auth_remote_datasource.dart';
import 'package:chatbox/features/data/datasource/features/chat_remote_datasource.dart';
import 'package:chatbox/features/data/repository/auth/google_auth_repo_imple.dart';
import 'package:chatbox/features/data/repository/features/chat_repository_imple.dart';
import 'package:chatbox/features/domain/repository/auth/google_auth_repository.dart';
import 'package:chatbox/features/domain/repository/pages/chat_repository.dart';
import 'package:chatbox/features/domain/usecases/auth/google_sign_in_usecase.dart';
import 'package:chatbox/features/domain/usecases/auth/google_sign_out_usecase.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/delete_message_usecase.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/get_chat_messages_usecase.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/get_user_chats_usecase.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/send_message_usecase.dart';
import 'package:chatbox/features/domain/usecases/pages/chat/update_unread_usecase.dart';
import 'package:chatbox/features/presentation/controller/auth/google_auth_controller.dart';
import 'package:chatbox/features/presentation/controller/pages/chat_controller.dart';
import 'package:chatbox/features/presentation/controller/pages/chat_detail_controller.dart';
import 'package:get/get.dart';

Future<void>initializeDependencies()async{
  //Data source
  Get.lazyPut<GoogleAuthRemoteDatasource>(()=>GoogleAuthRemoteDatasource());
  Get.lazyPut<ChatRemoteDatasource>(()=>ChatRemoteDatasource());

  //repository
  Get.lazyPut<GoogleAuthRepository>(()=>GoogleAuthRepoImple(datasource: Get.find<GoogleAuthRemoteDatasource>()));
  Get.lazyPut<ChatRepository>(()=>ChatRepositoryImple(datasource: Get.find<ChatRemoteDatasource>()));
 
  //use cases
  Get.lazyPut<GoogleSignInUsecase>(()=>GoogleSignInUsecase(Get.find<GoogleAuthRepository>()));
  Get.lazyPut<GoogleSignOutUsecase>(()=>GoogleSignOutUsecase(Get.find<GoogleAuthRepository>()));

  Get.lazyPut<GetUserChatsUsecase>(()=>GetUserChatsUsecase(Get.find<ChatRepository>()));
  Get.lazyPut<SendMessageUsecase>(()=>SendMessageUsecase(Get.find<ChatRepository>()));
  Get.lazyPut<GetChatMessagesUsecase>(()=>GetChatMessagesUsecase(Get.find<ChatRepository>()));
  Get.lazyPut<DeleteMessageUsecase>(()=>DeleteMessageUsecase(Get.find<ChatRepository>()));
  Get.lazyPut<UpdateUnreadUsecase>(()=>UpdateUnreadUsecase(Get.find<ChatRepository>()));

  //Controllers
  Get.lazyPut<GoogleAuthController>(()=>GoogleAuthController(Get.find<GoogleSignInUsecase>(), Get.find<GoogleSignOutUsecase>()));
  Get.lazyPut<ChatController>(()=>ChatController(Get.find<GetUserChatsUsecase>(), Get.find<UpdateUnreadUsecase>()));
  Get.lazyPut<ChatDetailController>(()=>ChatDetailController(Get.find<SendMessageUsecase>(), Get.find<GetChatMessagesUsecase>(), Get.find<DeleteMessageUsecase>()));
}