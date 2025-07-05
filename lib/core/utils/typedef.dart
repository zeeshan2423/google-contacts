import 'package:google_contacts/core/constants/imports.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid<T> = ResultFuture<void>;

typedef DataMap = Map<String, dynamic>;
