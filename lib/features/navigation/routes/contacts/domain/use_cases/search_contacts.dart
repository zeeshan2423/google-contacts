import 'package:google_contacts/core/constants/imports.dart';

class SearchContacts extends UseCaseWithParams<void, SearchContactParams> {
  const SearchContacts(this._repository);

  final ContactsRepository _repository;

  @override
  ResultFuture<List<Contact>> call(SearchContactParams params) async =>
      _repository.searchContacts(query: params.query);
}

class SearchContactParams extends Equatable {
  const SearchContactParams({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}
