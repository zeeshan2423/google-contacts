import 'package:google_contacts/core/constants/imports.dart';

extension AppPageExtension on PAGES {
  String get screenPath {
    switch (this) {
      case PAGES.contacts:
        return '/contacts';
    }
  }

  String get screenName {
    switch (this) {
      case PAGES.contacts:
        return 'CONTACTS';
    }
  }

  String get screenTitle {
    switch (this) {
      case PAGES.contacts:
        return 'Contacts';
    }
  }
}
