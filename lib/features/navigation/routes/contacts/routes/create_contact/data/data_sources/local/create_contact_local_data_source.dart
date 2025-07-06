import 'package:google_contacts/core/constants/imports.dart';

class CreateContactLocalDataSource {
  static Database? _database;
  static const String _tableName = 'contacts';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'contacts.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        firstName TEXT,
        middleName TEXT,
        surname TEXT,
        phoneNumber TEXT,
        email TEXT,
        birthday TEXT,
        address TEXT,
        company TEXT, 
        title TEXT,
        department TEXT,
        notes TEXT,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertContact(ContactModel contact) async {
    final db = await database;
    await db.insert(_tableName, contact.toMap());
  }

  Future<void> updateContact(ContactModel contact) async {
    final db = await database;
    await db.update(
      _tableName,
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }
}
