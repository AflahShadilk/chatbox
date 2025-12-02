import 'package:chatbox/features/domain/entities/pages/contact_entities.dart';
import 'package:chatbox/features/domain/repository/pages/contact_repository.dart';

class GetContactsUsecase {
  final ContactRepository repository;

  const GetContactsUsecase(this.repository);
  Future<List<ContactEntities>> call() async {
    return await repository.getContacts();
  }
}
