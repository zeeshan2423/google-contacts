import 'package:google_contacts/core/constants/imports.dart';

class LocalDatabase {
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
      version: 1,
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

  Future<List<ContactModel>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => ContactModel.fromMap(maps[i]));
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

  Future<void> deleteContact(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleFavorite(String id) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      columns: ['isFavorite'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final currentValue = result.first['isFavorite'] as int;
      final newValue = currentValue == 1 ? 0 : 1;

      await db.update(
        _tableName,
        {'isFavorite': newValue, 'updatedAt': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<List<ContactModel>> searchContacts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '''
  LOWER(firstName) LIKE LOWER(?) OR 
  LOWER(middleName) LIKE LOWER(?) OR 
  LOWER(surname) LIKE LOWER(?) OR 
  LOWER(phoneNumber) LIKE LOWER(?) OR 
  LOWER(email) LIKE LOWER(?)
''',
      whereArgs: List.filled(5, '%$query%'),
    );
    return List.generate(maps.length, (i) => ContactModel.fromMap(maps[i]));
  }
}
