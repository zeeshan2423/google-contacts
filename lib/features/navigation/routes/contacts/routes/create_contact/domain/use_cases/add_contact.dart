import 'package:google_contacts/core/constants/imports.dart';

class AddContact extends UseCaseWithParams<void, AddContactParams> {
  const AddContact(this._repository);

  final CreateContactRepository _repository;

  @override
  ResultVoid<void> call(AddContactParams params) async =>
      _repository.addContact(contact: params.contact);
}

class AddContactParams extends Equatable {
  const AddContactParams({
    required this.contact,
  });

  final Contact contact;

  @override
  List<Object?> get props => [contact];
}
