import 'package:chatbox/features/data/datasource/auth/google_auth_remote_datasource.dart';
import 'package:chatbox/features/domain/entities/auth/google_entities.dart';
import 'package:chatbox/features/domain/repository/auth/google_auth_repository.dart';

class GoogleAuthRepoImple implements GoogleAuthRepository {
  final GoogleAuthRemoteDatasource datasource;
  const GoogleAuthRepoImple({required this.datasource});

  @override
  Future<GoogleEntities?> signInWithGoogle() => datasource.signInWithGoogle();

  @override
  Future<void> signOut() => datasource.signOut();

  @override
  Future<void> updatePhoneNumber(String userId, String phoneNumber) =>
      datasource.updatePhoneNumber(userId, phoneNumber);

  @override
  Future<bool> checkIfUserHasPhoneNumber(String userId) =>
      datasource.checkIfUserHasPhoneNumber(userId);
}