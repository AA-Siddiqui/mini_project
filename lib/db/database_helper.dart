import 'package:mini_project/models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '2.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        avatarPath TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        name TEXT,
        category TEXT,
        amount REAL,
        date TEXT,
        imagePaths TEXT,
        sharedWith TEXT,
        isShared INTEGER,
        sharedByUserId INTEGER
      );
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return db
        .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;

// Now create individual entries for sharedWith users
    for (final entry in expense.sharedWith.entries) {
      final userId = entry.key;
      final percentage = entry.value;

      if (userId != expense.userId) {
        final sharedExpense = Expense(
          userId: userId,
          name: expense.name,
          category: expense.category,
          amount: expense.amount * (percentage / 100),
          date: expense.date,
          imagePaths: expense.imagePaths,
          isShared: true,
          sharedByUserId: expense.userId,
        );

        await db.insert('expenses', sharedExpense.toMap());
      }
    }

    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getAllExpenses(int userId) async {
    final db = await database;
    final res =
        await db.query('expenses', where: 'userId = ?', whereArgs: [userId]);
    return res.map((e) => Expense.fromMap(e)).toList();
  }

  Future<int> updateExpense(Expense exp) async {
    final db = await database;
    return await db
        .update('expenses', exp.toMap(), where: 'id = ?', whereArgs: [exp.id]);
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final res = await db.query('users');
    return res.map((e) => User.fromMap(e)).toList();
  }
}
