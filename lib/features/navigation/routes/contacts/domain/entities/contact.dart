import 'package:google_contacts/core/constants/imports.dart';

class Contact extends Equatable {
  const Contact({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.middleName,
    this.surname,
    this.phoneNumber,
    this.email,
    this.birthday,
    this.address,
    this.company,
    this.title,
    this.department,
    this.notes,
    this.isFavorite = false,
  });

  final String id;
  final String? firstName;
  final String? middleName;
  final String? surname;
  final String? phoneNumber;
  final String? email;
  final String? birthday;
  final String? address;
  final String? company;
  final String? title;
  final String? department;
  final String? notes;
  final bool isFavorite;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Contact copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? surname,
    String? phoneNumber,
    String? email,
    String? birthday,
    String? address,
    String? company,
    String? title,
    String? department,
    String? notes,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
      company: company ?? this.company,
      title: title ?? this.title,
      department: department ?? this.department,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    middleName,
    surname,
    phoneNumber,
    email,
    birthday,
    address,
    company,
    title,
    department,
    notes,
    isFavorite,
    createdAt,
    updatedAt,
  ];
}
