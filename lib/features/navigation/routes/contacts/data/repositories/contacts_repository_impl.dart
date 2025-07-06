import 'package:google_contacts/core/constants/imports.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  const ContactsRepositoryImpl(this._localDataSource);

  final LocalDatabase _localDataSource;

  @override
  ResultFuture<List<Contact>> getContacts() async {
    try {
      final result = await _localDataSource.getContacts();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
