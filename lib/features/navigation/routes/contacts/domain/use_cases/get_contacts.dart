import 'package:google_contacts/core/constants/imports.dart';

class GetContacts extends UseCaseWithoutParams<List<Contact>> {
  const GetContacts(this._repository);

  final ContactsRepository _repository;

  @override
  ResultFuture<List<Contact>> call() async => _repository.getContacts();
}
