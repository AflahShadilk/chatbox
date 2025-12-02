import 'package:chatbox/features/data/datasource/features/contacts_datasource.dart';
import 'package:chatbox/features/domain/entities/pages/contact_entities.dart';
import 'package:chatbox/features/domain/repository/pages/contact_repository.dart';

class ContactsRepositoryImple implements ContactRepository{
  final ContactsDatasource datasource;

  const ContactsRepositoryImple(this.datasource);

  @override
  Future<List<ContactEntities>> getContacts() async{
    return await datasource.getPhoneContacts();
  }
}