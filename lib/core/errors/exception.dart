import 'package:google_contacts/core/constants/imports.dart';

class ServerException extends Equatable implements Exception {
  const ServerException({required this.message, this.statusCode});

  final String message;

  final String? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
