import 'package:google_contacts/core/constants/imports.dart';

abstract class ContactDetailRepository {
  ResultVoid<void> deleteContact({required String id});

  ResultVoid<void> toggleFavorite({required String id});
}
