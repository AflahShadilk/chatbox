import 'package:chatbox/features/domain/repository/auth/google_auth_repository.dart';

class GoogleSignOutUsecase {
  final GoogleAuthRepository repository;
  const GoogleSignOutUsecase(this.repository);
   Future<void>signOut()=>  repository.signOut();
 
}