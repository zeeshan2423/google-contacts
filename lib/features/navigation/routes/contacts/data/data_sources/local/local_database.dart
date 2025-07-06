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

  Future<void> insertDummyContacts() async {
    final db = LocalDatabase();
    final now = DateTime.now();

    final sampleFirstNames = [
      'Alice',
      'Bob',
      'Charlie',
      'David',
      'Eva',
      'Frank',
      'Grace',
      'Hank',
      'Ivy',
      'Jack',
    ];
    final sampleSurnames = [
      'Smith',
      'Johnson',
      'Williams',
      'Brown',
      'Jones',
      'Miller',
      'Davis',
      'Garcia',
      'Taylor',
      'Lee',
    ];
    final sampleCompanies = ['TechCorp', 'DesignX', 'FinServe', 'HealthHub'];
    final sampleTitles = ['Manager', 'Developer', 'Analyst', 'Designer'];
    final sampleDepartments = ['IT', 'HR', 'Finance', 'Marketing'];

    for (var i = 0; i < 20; i++) {
      final firstName = sampleFirstNames[i % sampleFirstNames.length];
      final surname = sampleSurnames[i % sampleSurnames.length];
      final phone = '+12345678${100 + i}';
      final email = '${firstName.toLowerCase()}.$i@example.com';
      final birthday = '199${i % 10}-0${(i % 9) + 1}-1${(i % 9) + 1}';

      final contact = ContactModel(
        id: const Uuid().v4(),
        firstName: firstName,
        surname: surname,
        phoneNumber: phone,
        email: email,
        birthday: birthday,
        address: '123 Sample Street, City',
        company: sampleCompanies[i % sampleCompanies.length],
        title: sampleTitles[i % sampleTitles.length],
        department: sampleDepartments[i % sampleDepartments.length],
        notes: 'Test contact #$i',
        isFavorite: i % 4 == 0,
        createdAt: now,
        updatedAt: now,
      );

      await db.insertContact(contact);
    }

    debugPrint('✅ 20 dummy contacts inserted.');
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
      where: 'name LIKE ? OR phoneNumber LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => ContactModel.fromMap(maps[i]));
  }
}
