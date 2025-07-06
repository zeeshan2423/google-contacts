import 'package:google_contacts/core/constants/imports.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit({
    required GetContacts getContacts,
  }) : _getContacts = getContacts,
       super(const ContactsInitial()) {
    loadContacts();
  }

  final GetContacts _getContacts;

  Future<void> loadContacts() async {
    emit(const ContactsInProgress());
    try {
      final contactsResult = await _getContacts();
      contactsResult.fold(
        (failure) => emit(ContactsFailure(failure.message)),
        (contacts) => emit(ContactsSuccess(contacts)),
      );
    } on Exception catch (e) {
      emit(ContactsFailure(e.toString()));
    }
  }
}
