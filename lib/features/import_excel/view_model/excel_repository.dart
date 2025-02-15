import 'package:academic_planner_for_it/features/home_screen/view_models/all_event_list_notifier.dart';
import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:academic_planner_for_it/utilities/constants/constants.dart';
import 'package:academic_planner_for_it/utilities/services/database.dart';
import 'package:academic_planner_for_it/utilities/services/notification_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../../../utilities/constants/date_formatter.dart';
import '../../home_screen/models/events.dart';

/// Provides an instance of [ExcelRepository].
///
/// This provider allows widgets to access the [ExcelRepository] for database operations.
final excelRepositoryProvider = Provider<ExcelRepository>((ref) {
  final dbFuture = ref.read(databaseProvider);
  return ExcelRepository(dbFuture, ref);
});

final NotificationServices notificationServices = NotificationServices();

/// A repository for managing Excel data in the database.
///
/// This class handles saving Excel data to the database and scheduling notifications for events.
class ExcelRepository {
  final Future<Database> _dbFuture;
  final Ref _ref;

  /// Creates an [ExcelRepository].
  ///
  /// Parameters:
  ///   - [_dbFuture]: A [Future] that resolves to a [Database] instance.
  ///   - [_ref]: A [Ref] instance for interacting with Riverpod.
  ExcelRepository(this._dbFuture, this._ref);

  /// Gets the database instance.
  Future<Database> get _db async => _dbFuture;

  /// Saves a list of [ExcelData] to the database.
  ///
  /// This method inserts the given Excel data into the database, schedules
  /// notifications for each event, and updates the all events list.
  ///
  /// Parameters:
  ///   - [excelData]: The list of [ExcelData] to save.
  ///
  /// Throws:
  ///   - An exception if there is an error saving the data.
  Future<void> saveExcelDataToDb(List<ExcelData> excelData) async {
    try {
      final db = await _db;
      List<Events> newEvents = [];
      for (var data in excelData) {
        final existingEvents = await AppDatabase.instance
            .eventExists(data.eventName, data.dateTime);

        if (existingEvents) {
          continue;
        }
        int generatedId = await db.insert(
          kEventsTable,
          data.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        data = data.copyWith(id: generatedId);
        _scheduleNotification(data);
        newEvents.add(
          Events(
            eventName: data.eventName,
            dateTime: data.dateTime,
            id: data.id,
          ),
        );
      }
      _ref.read(allEventsProvider.notifier).addMultipleEvents(newEvents);
    } catch (e) {
      throw Exception('Error saving Excel data: $e');
    }
  }

  /// Schedules a notification for the given [ExcelData].
  ///
  /// This method schedules a notification for the event if its date and time
  /// are in the future.
  ///
  /// Parameters:
  ///   - [excelData]: The [ExcelData] for which to schedule a notification.
  ///
  /// Throws:
  ///   - An exception if there is an error scheduling the notification.
  void _scheduleNotification(ExcelData excelData) async {
    try {
      if (excelData.dateTime.isAfter(DateTime.now())) {
        await notificationServices.scheduleNotification(
          excelData.id,
          'Event Reminder',
          excelData.eventName,
          excelData.dateTime,
          "${excelData.eventName} - ${returnDate(excelData.dateTime)}",
        );
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
