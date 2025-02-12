// Project Package
import 'dart:async';

import 'package:academic_planner_for_it/utilities/constants/constants.dart';
import 'package:academic_planner_for_it/utilities/services/notification_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
//Project Class
import '../../../utilities/constants/date_formatter.dart';
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

  Future<List<Events>> loadEventsPaginated(
      {required int page, required int pageSize}) async {
    try {
      final db = await _db;
      final int offset = (page - 1) * pageSize;
      final List<Map<String, dynamic>> eventMap = await db.query(
        kEventsTable,
        limit: pageSize,
        offset: offset,
        orderBy: 'dateTime ASC',
      );
      final events = List.generate(
        eventMap.length,
        (i) {
          return Events.fromMap(eventMap[i]);
        },
      );
      return events;
    } catch (e) {
      throw Exception('Error loading paginated events: $e');
    }
  }

  Future<int> getTotalEventCount() async {
    try {
      final db = await _db;
      final result = await db.rawQuery(kTableCount);
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error getting total event count: $e');
    }
  }

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
      final existingEvents = await db.query(
        kEventsTable,
        where: 'eventName = ? AND dateTime = ?',
        whereArgs: [
          event.eventName,
          event.dateTime.toIso8601String(),
        ],
      );
      if (existingEvents.isNotEmpty) {
        return;
      }

      int generatedId = await db.insert(
        kEventsTable,
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      event = event.copyWith(id: generatedId);
      _scheduleNotification(event);
    } catch (e) {
      throw Exception('Error in adding event: $e');
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
          "${event.eventName} - ${returnDate(event.dateTime)}",
        );
      }
    } catch (e) {
      throw Exception('$e');
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
      throw Exception('$e');
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
      throw Exception('$e');
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
      throw Exception('Error clearing database: $e');
    }
  }
}
