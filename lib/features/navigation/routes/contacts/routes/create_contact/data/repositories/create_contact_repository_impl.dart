import 'package:google_contacts/core/constants/imports.dart';

class CreateContactRepositoryImpl implements CreateContactRepository {
  const CreateContactRepositoryImpl(this._localDataSource);

  final LocalDatabase _localDataSource;

  @override
  ResultVoid<void> addContact({required Contact contact}) async {
    try {
      final result = await _localDataSource.insertContact(
        ContactModel(
          id: contact.id,
          createdAt: contact.createdAt,
          updatedAt: contact.updatedAt,
          firstName: contact.firstName,
          middleName: contact.middleName,
          surname: contact.surname,
          phoneNumber: contact.phoneNumber,
          email: contact.email,
          birthday: contact.birthday,
          address: contact.address,
          company: contact.company,
          title: contact.title,
          department: contact.department,
          notes: contact.notes,
          isFavorite: contact.isFavorite,
        ),
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultVoid<void> updateContact({required Contact contact}) async {
    try {
      final result = await _localDataSource.updateContact(
        ContactModel.fromJson(contact.toString()),
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
