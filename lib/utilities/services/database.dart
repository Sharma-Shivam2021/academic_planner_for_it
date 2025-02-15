import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Provides a [Future<Database>] instance using Riverpod.
///
/// This provider allows easy access to the application's database throughout the app.
final databaseProvider = Provider<Future<Database>>((ref) {
  final database = AppDatabase.instance;
  return database.database();
});

/// A singleton class for managing the application's SQLite database.
///
/// This class provides methods for initializing the database, creating tables,
/// checking for the existence of events, and closing the database.
class AppDatabase {
  /// The singleton instance of [AppDatabase].
  static final AppDatabase instance = AppDatabase._init();

  /// The underlying [Database] instance.
  static Database? _database;

  /// Private constructor to prevent external instantiation.
  AppDatabase._init();

  /// Returns the database instance.
  ///
  /// If the database is not yet initialized, it initializes it.
  ///
  /// Returns:
  ///   A [Future] that completes with the [Database] instance.
  ///
  /// Throws an exception if there is an error initializing the database.
  Future<Database> database() async {
    try {
      if (_database != null) return _database!;

      _database = await _initDB('academicPlanner.db');
      return _database!;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Initializes the database at the specified file path.
  ///
  /// Parameters:
  ///   - [filePath]: The name of the database file.
  ///
  /// Returns:
  ///   A [Future] that completes with the initialized [Database] instance.
  ///
  /// Throws an exception if there is an error initializing the database.
  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(path, onCreate: _createDB, version: 1);
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Creates the database tables.
  ///
  /// Parameters:
  ///   - [db]: The [Database] instance.
  ///   - [version]: The database version.
  ///
  /// Throws an exception if there is an error creating the tables.
  Future<void> _createDB(Database db, int version) async {
    try {
      await _createEventsTable(db);
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Creates the 'events' table in the database.
  ///
  /// Parameters:
  ///   - [db]: The [Database] instance.
  ///
  /// Throws an exception if there is an error creating the table.
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

  /// Checks if an event with the given name and date/time already exists.
  ///
  /// Parameters:
  ///   - [eventName]: The name of the event.
  ///   - [dateTime]: The date and time of the event.
  ///
  /// Returns:
  ///   A [Future] that completes with `true` if the event exists, `false` otherwise.
  ///
  /// Throws an exception if there is an error querying the database.
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

  /// Closes the database connection.
  ///
  /// Throws an exception if there is an error closing the database.
  Future<void> closeDB() async {
    try {
      await _database!.close();
    } catch (e) {
      throw Exception('$e');
    }
  }
}
