import 'package:google_contacts/core/constants/imports.dart';

extension AppPageExtension on PAGES {
  String get screenPath {
    switch (this) {
      case PAGES.contacts:
        return '/';
      case PAGES.createContact:
        return 'create-contact';
      case PAGES.favorites:
        return '/favorites';
    }
  }

  String get screenName {
    switch (this) {
      case PAGES.contacts:
        return 'CONTACTS';
      case PAGES.createContact:
        return 'CREATE_CONTACT';
      case PAGES.favorites:
        return 'FAVORITES';
    }
  }

  String get screenTitle {
    switch (this) {
      case PAGES.contacts:
        return 'Contacts';
      case PAGES.createContact:
        return 'Create Contact';
      case PAGES.favorites:
        return 'Favorites';
    }
  }
}
