import 'package:chatbox/features/domain/entities/pages/contact_entities.dart';

abstract class ContactRepository {
  Future<List<ContactEntities>>getContacts();
}