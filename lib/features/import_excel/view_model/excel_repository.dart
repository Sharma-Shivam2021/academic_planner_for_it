import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:academic_planner_for_it/utilities/constants/constants.dart';
import 'package:academic_planner_for_it/utilities/services/database.dart';
import 'package:academic_planner_for_it/utilities/services/notification_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final excelRepositoryProvider = Provider<ExcelRepository>((ref) {
  final dbFuture = ref.read(databaseProvider);
  return ExcelRepository(dbFuture);
});

final NotificationServices notificationServices = NotificationServices();

class ExcelRepository {
  final Future<Database> _dbFuture;

  ExcelRepository(this._dbFuture);

  Future<Database> get _db async => _dbFuture;

  Future<void> saveExcelDataToDb(List<ExcelData> excelData) async {
    try {
      final db = await _db;
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
      }
    } catch (e) {
      throw Exception('Error saving Excel data: $e');
    }
  }

  void _scheduleNotification(ExcelData excelData) async {
    try {
      if (excelData.dateTime.isAfter(DateTime.now())) {
        await notificationServices.scheduleNotification(
          excelData.id,
          'Event Reminder',
          excelData.eventName,
          excelData.dateTime,
          "${excelData.eventName} on ${excelData.dateTime.day}/${excelData.dateTime.month}/${excelData.dateTime.year}",
        );
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
