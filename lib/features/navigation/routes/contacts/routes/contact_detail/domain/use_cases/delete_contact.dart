import 'package:google_contacts/core/constants/imports.dart';

class DeleteContact extends UseCaseWithParams<void, DeleteContactParams> {
  const DeleteContact(this._repository);

  final ContactDetailRepository _repository;

  @override
  ResultVoid<void> call(DeleteContactParams params) async =>
      _repository.deleteContact(id: params.id);
}

class DeleteContactParams extends Equatable {
  const DeleteContactParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
