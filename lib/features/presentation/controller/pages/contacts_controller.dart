import 'package:chatbox/core/message/snack_bar_handler.dart';
import 'package:chatbox/features/domain/entities/pages/contact_entities.dart';
import 'package:chatbox/features/domain/usecases/pages/contacts/get_contacts_usecase.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController {
  final GetContactsUsecase getContactsUsecase;

  final RxList<ContactEntities> allContacts = <ContactEntities>[].obs;
  final RxList<ContactEntities> registeredContacts = <ContactEntities>[].obs;

  final RxBool isLoading = false.obs;

  ContactsController(this.getContactsUsecase);

  @override
  void onInit() {
    super.onInit();
    loadContacts();
  }

  Future<void> loadContacts() async {
    isLoading.value = true;
    try {
      final contacts = await getContactsUsecase.call();
      allContacts.assignAll(contacts);
      registeredContacts.assignAll(
          contacts.where((contact) => contact.isRegistered).toList());
      SnackBarHelper.success(
          '${registeredContacts.length} contacts found on app');
    } catch (e) {
      SnackBarHelper.error('Failed to load contacts: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void searchContacts(String query) {
    if (query.isEmpty) {
      registeredContacts.assignAll(
          allContacts.where((contact) => contact.isRegistered).toList());
    } else {
      registeredContacts.assignAll(allContacts
          .where((contact) =>
              contact.isRegistered &&
              contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }
}
