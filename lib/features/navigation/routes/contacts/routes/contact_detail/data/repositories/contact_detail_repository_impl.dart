import 'package:google_contacts/core/constants/imports.dart';

class ContactDetailRepositoryImpl implements ContactDetailRepository {
  const ContactDetailRepositoryImpl(this._localDataSource);

  final LocalDatabase _localDataSource;

  @override
  ResultVoid<void> deleteContact({required String id}) async {
    try {
      final result = await _localDataSource.deleteContact(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultVoid<void> toggleFavorite({required String id}) async {
    try {
      final result = await _localDataSource.toggleFavorite(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
