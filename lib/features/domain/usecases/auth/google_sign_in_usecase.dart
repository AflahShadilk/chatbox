import 'package:chatbox/features/domain/entities/auth/google_entities.dart';
import 'package:chatbox/features/domain/repository/auth/google_auth_repository.dart';

class GoogleSignInUsecase {
  final GoogleAuthRepository repository;
  const GoogleSignInUsecase(this.repository);
  Future<GoogleEntities?>call(){
    return repository.signInWithGoogle();
  }
}