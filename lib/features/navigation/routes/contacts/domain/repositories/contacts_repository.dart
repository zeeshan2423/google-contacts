import 'package:google_contacts/core/constants/imports.dart';

abstract class ContactsRepository {
  ResultFuture<List<Contact>> getContacts();

  ResultFuture<List<Contact>> searchContacts({required String query});
}
