import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/hosteller/domain/hosteller_model.dart';
import '../../features/payments/domain/payment_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hostel.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hostellers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        roomNo TEXT NOT NULL,
        rent REAL NOT NULL,
        joiningDate TEXT NOT NULL,
        isActive INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hostellerId INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        mode TEXT NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        FOREIGN KEY (hostellerId) REFERENCES hostellers (id) ON DELETE CASCADE
      )
    ''');
  }

  // Hosteller methods
  Future<int> insertHosteller(Hosteller hosteller) async {
    final db = await instance.database;
    return await db.insert('hostellers', hosteller.toMap());
  }

  Future<List<Hosteller>> getAllHostellers() async {
    final db = await instance.database;
    final result = await db.query('hostellers', orderBy: 'name ASC');
    return result.map((json) => Hosteller.fromMap(json)).toList();
  }

  Future<int> updateHosteller(Hosteller hosteller) async {
    final db = await instance.database;
    return await db.update(
      'hostellers',
      hosteller.toMap(),
      where: 'id = ?',
      whereArgs: [hosteller.id],
    );
  }

  Future<int> deleteHosteller(int id) async {
    final db = await instance.database;
    return await db.delete(
      'hostellers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Payment methods
  Future<int> insertPayment(Payment payment) async {
    final db = await instance.database;
    return await db.insert('payments', payment.toMap());
  }

  Future<List<Payment>> getPaymentsByHosteller(int hostellerId) async {
    final db = await instance.database;
    final result = await db.query(
      'payments',
      where: 'hostellerId = ?',
      whereArgs: [hostellerId],
      orderBy: 'date DESC',
    );
    return result.map((json) => Payment.fromMap(json)).toList();
  }

  Future<List<Payment>> getAllPayments() async {
    final db = await instance.database;
    final result = await db.query('payments', orderBy: 'date DESC');
    return result.map((json) => Payment.fromMap(json)).toList();
  }
}
