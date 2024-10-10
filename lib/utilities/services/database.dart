import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = Provider<Future<Database>>((ref) {
  final database = AppDatabase.instance;
  return database.database();
});

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> database() async {
    try {
      if (_database != null) return _database!;

      _database = await _initDB('academicPlanner.db');
      return _database!;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(path, onCreate: _createDB, version: 1);
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      await _createEventsTable(db);
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> _createEventsTable(Database db) async {
    try {
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const textType = 'TEXT NOT NULL';
      const intType = 'INTEGER NOT NULL';

      await db.execute('''
    CREATE TABLE events (
      id $idType,
      eventName $textType,
      dateTime $textType,
      eventNotificationState $intType
    )
  ''');
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<bool> eventExists(String eventName, DateTime dateTime) async {
    try {
      final db = await database();
      final result = await db.query(
        'events',
        where: 'eventName = ? AND dateTime = ?',
        whereArgs: [
          eventName,
          dateTime.toIso8601String(),
        ],
      );
      return result.isNotEmpty;
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> closeDB() async {
    try {
      await _database!.close();
    } catch (e) {
      throw Exception('$e');
    }
  }
}
