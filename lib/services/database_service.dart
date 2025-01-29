import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            email TEXT,
            password TEXT,
            name TEXT,
            surname TEXT,
            phoneNumber TEXT,
            birthDate TEXT,
            imagePath TEXT
          )''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE users ADD COLUMN imagePath TEXT');
        }
      },
    );
  }

  Future<void> insertUser(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(
      'users',
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateUserImage(String email, String imagePath) async {
    final db = await database;
    await db.update(
      'users',
      {'imagePath': imagePath},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
