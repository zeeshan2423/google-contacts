import 'package:google_contacts/core/constants/imports.dart';

class UpdateContact extends UseCaseWithParams<void, UpdateContactParams> {
  const UpdateContact(this._repository);

  final CreateContactRepository _repository;

  @override
  ResultVoid<void> call(UpdateContactParams params) async =>
      _repository.updateContact(contact: params.contact);
}

class UpdateContactParams extends Equatable {
  const UpdateContactParams({
    required this.contact,
  });

  final Contact contact;

  @override
  List<Object?> get props => [contact];
}
