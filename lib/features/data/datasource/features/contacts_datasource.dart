import 'package:chatbox/features/domain/entities/pages/contact_entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsDatasource {
  final FirebaseFirestore firestore;
  const ContactsDatasource(this.firestore);

  Future<List<ContactEntities>>getPhoneContacts()async{
    final permission=await Permission.contacts.request();

    if(permission.isGranted){
      final contacts=await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      List<ContactEntities>contactsList=[];
      for(var contact in contacts){
        if(contact.phones.isNotEmpty){
          final phone=_cleanPhoneNumber(contact.phones.first.number);

          final isRegistered= await _checkIfRegistered(phone);
          final userId=isRegistered ? await _getUserId(phone):null;
          contactsList.add(ContactEntities(id: contact.id, name:contact.displayName, phoneNumber: phone,isRegistered: isRegistered,userId: userId));
        }
      }
      return contactsList;
    }else{
      throw Exception('Contact permission denied');
    }

  }
  
    Future<bool> _checkIfRegistered(String phone) async {
    final snapshot = await firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phone)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<String?> _getUserId(String phone) async {
    final snapshot = await firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phone)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  String _cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }
}