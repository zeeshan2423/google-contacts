import 'package:google_contacts/core/constants/imports.dart';

abstract class CreateContactRepository {
  ResultVoid<void> addContact({required Contact contact});

  ResultVoid<void> updateContact({required Contact contact});
}
