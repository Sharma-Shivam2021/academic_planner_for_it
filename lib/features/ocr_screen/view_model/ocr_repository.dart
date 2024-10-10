import 'package:academic_planner_for_it/features/ocr_screen/model/ocr_model.dart';
import 'package:academic_planner_for_it/utilities/constants/constants.dart';
import 'package:academic_planner_for_it/utilities/services/database.dart';
import 'package:academic_planner_for_it/utilities/services/notification_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  final dbFuture = ref.read(databaseProvider);
  return OcrRepository(dbFuture);
});

final NotificationServices notificationServices = NotificationServices();

class OcrRepository {
  final Future<Database> _dbFuture;

  OcrRepository(this._dbFuture);

  Future<Database> get _db async => _dbFuture;

  Future<void> saveOcrDataToDb(List<OCRData> ocrData) async {
    try {
      final db = await _db;
      for (var data in ocrData) {
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
      throw Exception('Error saving OCR data: $e');
    }
  }

  void _scheduleNotification(OCRData ocrData) async {
    try {
      if (ocrData.dateTime.isAfter(DateTime.now())) {
        await notificationServices.scheduleNotification(
          ocrData.id,
          'Event Reminder',
          ocrData.eventName,
          ocrData.dateTime,
          ocrData.eventName,
        );
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
