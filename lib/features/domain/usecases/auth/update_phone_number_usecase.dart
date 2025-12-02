import 'package:chatbox/features/domain/repository/auth/google_auth_repository.dart';

class UpdatePhoneNumberUsecase {
  final GoogleAuthRepository repository;
  const UpdatePhoneNumberUsecase(this.repository);

  Future<void> call(String userId, String phoneNumber) {
    return repository.updatePhoneNumber(userId, phoneNumber);
  }
}