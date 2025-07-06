import 'package:google_contacts/core/constants/imports.dart';

part 'contact_detail_state.dart';

class ContactDetailCubit extends Cubit<ContactDetailState> {
  ContactDetailCubit({
    required ToggleFavorite toggleFavorite,
    required DeleteContact deleteContact,
  }) : _toggleFavorite = toggleFavorite,
       _deleteContact = deleteContact,
       super(const ContactDetailInitial());

  final ToggleFavorite _toggleFavorite;
  final DeleteContact _deleteContact;

  final isFavorite = ValueNotifier<bool>(false);

  Future<void> toggleContactFavorite(String id) async {
    emit(const ContactDetailInProgress());
    try {
      isFavorite.value = !isFavorite.value;
      final toggleFavoriteResult = await _toggleFavorite(
        ToggleFavoriteParams(id: id),
      );
      toggleFavoriteResult.fold(
        (failure) => emit(ContactDetailFailure(failure.message)),
        (contact) => emit(const ContactDetailSuccess()),
      );
    } on Exception catch (e) {
      isFavorite.value = !isFavorite.value;
      emit(ContactDetailFailure(e.toString()));
    }
  }

  Future<void> removeContact(String id) async {
    emit(const ContactDetailInProgress());
    try {
      final deleteContactResult = await _deleteContact(
        DeleteContactParams(id: id),
      );
      deleteContactResult.fold(
        (failure) => emit(ContactDetailFailure(failure.message)),
        (contact) => emit(const ContactDeleteSuccess()),
      );
    } on Exception catch (e) {
      emit(ContactDetailFailure(e.toString()));
    }
  }
}
