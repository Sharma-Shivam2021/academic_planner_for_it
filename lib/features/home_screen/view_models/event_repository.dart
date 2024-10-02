// Project Package
import 'package:academic_planner_for_it/features/settings_screen/view_model/setting_notifier.dart';
import 'package:academic_planner_for_it/utilities/constants/constants.dart';
import 'package:academic_planner_for_it/utilities/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
//Project Class
import '../../../utilities/services/database.dart';
import '../models/events.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final dbFuture = ref.read(databaseProvider);
  return EventRepository(dbFuture);
});

final NotificationServices notificationServices = NotificationServices();

class EventRepository {
  final Future<Database> _dbFuture;

  EventRepository(this._dbFuture);

  Future<Database> get _db async => _dbFuture;

  Future<List<Events>> loadEvents() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> eventMap = await db.query(kEventsTable);
      final events = List.generate(
        eventMap.length,
        (i) {
          return Events.fromMap(eventMap[i]);
        },
      );
      return events;
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> addEvent(Events event) async {
    try {
      final db = await _db;
      int generatedId = await db.insert(
        kEventsTable,
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      event = event.copyWith(id: generatedId);
      _scheduleNotification(event);
    } catch (e) {
      debugPrint('Error in adding event: $e');
    }
  }

  void _scheduleNotification(Events event) async {
    try {
      await notificationServices.removeNotification(event.id);

      if (event.dateTime.isAfter(DateTime.now())) {
        await notificationServices.scheduleNotification(
          event.id,
          'Event Reminder',
          event.eventName,
          event.dateTime,
          event.eventName,
        );
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateEventNotificationState() async {
    try {
      final db = await _db;

      final List<Events> events = await loadEvents();
      final List<PendingNotificationRequest> pendingNotifications =
          await notificationServices.pendingNotificationRequest();

      final Set<int> pendingNotificationIds =
          pendingNotifications.map((req) => req.id).toSet();

      for (final event in events) {
        if (!pendingNotificationIds.contains(event.id)) {
          await db.update(
            kEventsTable,
            event
                .copyWith(
                    eventNotificationState: EventNotificationState.notified)
                .toMap(),
            where: 'id = ?',
            whereArgs: [event.id],
          );
        }
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> deleteEvent(Events deletingEvent) async {
    try {
      final db = await _db;
      await notificationServices.removeNotification(deletingEvent.id);
      await db.delete(
        kEventsTable,
        where: 'id = ?',
        whereArgs: [deletingEvent.id],
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> clearDatabase() async {
    try {
      final db = await _db;
      await db.transaction((txn) async {
        await notificationServices.cancelAllNotifications();
        await txn.delete(kEventsTable);
      });
    } catch (e) {
      debugPrint('Error clearing database: $e');
    }
  }
}
