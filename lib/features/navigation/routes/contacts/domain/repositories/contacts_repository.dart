import 'package:google_contacts/core/constants/imports.dart';

abstract class ContactsRepository {
  ResultFuture<List<Contact>> getContacts();

  // ResultFuture<Contact> getContact(String id);

  // ResultVoid<void> addContact(Contact contact);
  //
  // ResultVoid<void> updateContact(Contact contact);
  //
  // ResultVoid<void> deleteContact(String id);
  //
  // ResultVoid<void> toggleFavorite(String id);
  //
  // ResultFuture<List<Contact>> getFavoriteContacts();
  //
  // ResultFuture<List<Contact>> searchContacts(String query);
  //
  // ResultVoid<void> syncWithFirebase();
}
