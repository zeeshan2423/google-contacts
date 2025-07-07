import 'package:google_contacts/core/constants/imports.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit({
    required GetContacts getContacts,
    required SearchContacts searchContacts,
  }) : _getContacts = getContacts,
       _searchContacts = searchContacts,
       super(const ContactsInitial()) {
    loadContacts();
  }

  final GetContacts _getContacts;
  final SearchContacts _searchContacts;

  final searchController = TextEditingController();

  List<Contact>? contact;

  Future<void> loadContacts() async {
    emit(const ContactsInProgress());
    try {
      final contactsResult = await _getContacts();
      contactsResult.fold(
        (failure) => emit(ContactsFailure(failure.message)),
        (contacts) {
          emit(ContactsSuccess(contacts));
          contact = contacts;
        },
      );
    } on Exception catch (e) {
      emit(ContactsFailure(e.toString()));
    }
  }

  Future<void> searchForContacts(String query) async {
    if (query.isEmpty) {
      await loadContacts();
      return;
    }

    emit(const ContactsSearchInProgress());
    try {
      final searchContactsResult = await _searchContacts(
        SearchContactParams(query: query),
      );
      searchContactsResult.fold(
        (failure) => emit(ContactsFailure(failure.message)),
        (contacts) => emit(ContactsSearchSuccess(contacts)),
      );
    } on Exception catch (e) {
      emit(ContactsFailure(e.toString()));
    }
  }
}
