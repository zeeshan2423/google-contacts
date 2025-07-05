import 'package:google_contacts/core/constants/imports.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database;
  }
}
