import 'package:chatbox/features/domain/entities/auth/google_entities.dart';

abstract class GoogleAuthRepository {
  Future<GoogleEntities?>signInWithGoogle();
  Future<void>signOut();
}