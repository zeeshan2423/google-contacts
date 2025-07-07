import 'package:google_contacts/core/constants/imports.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required GetContacts getContacts,
  }) : _getContacts = getContacts,
       super(const FavoritesInitial()) {
    loadContacts();
  }

  final GetContacts _getContacts;

  Future<void> loadContacts() async {
    emit(const FavoritesInProgress());
    try {
      final contactsResult = await _getContacts();
      contactsResult.fold(
        (failure) => emit(FavoritesFailure(failure.message)),
        (contacts) {
          final favoriteContacts = contacts
              .where((c) => c.isFavorite == true)
              .toList();
          emit(FavoritesSuccess(favoriteContacts));
        },
      );
    } on Exception catch (e) {
      emit(FavoritesFailure(e.toString()));
    }
  }
}
