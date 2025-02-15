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

/// Provides an instance of [EventRepository].
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final dbFuture = ref.read(databaseProvider);
  return EventRepository(dbFuture);
});

/// An instance of [NotificationServices] for managing notifications.
final NotificationServices notificationServices = NotificationServices();

/// A repository for managing events in the database.
///
/// This class provides methods for loading, adding, deleting, and clearing events,
/// as well as scheduling and managing event notifications.

class EventRepository {
  /// Creates an [EventRepository].
  ///
  /// Parameters:
  ///   - [_dbFuture]: A future that resolves to a [Database] instance.
  EventRepository(this._dbFuture);

  final Future<Database> _dbFuture;

  /// Returns a [Database] instance.
  Future<Database> get _db async => _dbFuture;

  /// Loads a paginated list of events from the database.
  ///
  /// Parameters:
  ///   - [page]: The page number to load.
  ///   - [pageSize]: The number of events per page.
  ///
  /// Returns a [Future] that resolves to a list of [Events].
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

  /// Gets the total number of events in the database.
  ///
  /// Returns a [Future] that resolves to the total event count.
  Future<int> getTotalEventCount() async {
    try {
      final db = await _db;
      final result = await db.rawQuery(kTableCount);
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error getting total event count: $e');
    }
  }

  /// Loads all events from the database.
  ///
  /// Returns a [Future] that resolves to a list of [Events].
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

  /// Adds an event to the database.
  ///
  /// If an event with the same name and date/time already exists, it will not be added.
  ///
  /// Parameters:
  ///   - [event]: The [Events] to add.
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

  /// Schedules a notification for an event.
  ///
  /// If the event's date/time is in the past, no notification will be scheduled.
  ///
  /// Parameters:
  ///   - [event]: The [Events] to schedule a notification for.
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

  /// Updates the notification state of events in the database.
  ///
  /// This method checks for events that do not have a corresponding pending notification
  /// and updates their notification state to `EventNotificationState.notified`.
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

  /// Deletes an event from the database.
  ///
  /// Parameters:
  ///   - [deletingEvent]: The [Events] to delete.
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

  /// Clears all events from the database.
  ///
  /// This method also cancels all pending notifications.
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
