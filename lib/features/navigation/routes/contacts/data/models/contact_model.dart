import 'package:google_contacts/core/constants/imports.dart';

class ContactModel extends Contact {
  const ContactModel({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.firstName,
    super.middleName,
    super.surname,
    super.phoneNumber,
    super.email,
    super.birthday,
    super.address,
    super.company,
    super.title,
    super.department,
    super.notes,
    super.isFavorite = false,
  });

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(jsonDecode(source) as DataMap);

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
    id: map['id'] as String,
    firstName: map['firstName'] as String?,
    middleName: map['middleName'] as String?,
    surname: map['surname'] as String?,
    phoneNumber: map['phoneNumber'] as String?,
    email: map['email'] as String?,
    birthday: map['birthday'] as String?,
    address: map['address'] as String?,
    company: map['company'] as String?,
    title: map['title'] as String?,
    department: map['department'] as String?,
    notes: map['notes'] as String?,
    isFavorite: (map['isFavorite'] as int) == 1,
    createdAt: DateTime.parse(map['createdAt'] as String),
    updatedAt: DateTime.parse(map['updatedAt'] as String),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'firstName': firstName,
      'middleName': middleName,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'email': email,
      'birthday': birthday,
      'address': address,
      'company': company,
      'title': title,
      'department': department,
      'notes': notes,
      'isFavorite': isFavorite ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => jsonEncode(toMap());
}
