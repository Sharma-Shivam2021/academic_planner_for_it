import 'package:academic_planner_for_it/utilities/services/tts_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../constants/constants.dart';

final TTSService ttsService = TTSService();

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotification,
      onDidReceiveBackgroundNotificationResponse: _handleBackGroundNotification,
    );
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final status = await androidPlugin.requestNotificationsPermission();

      if (status != true) {
        final bool? granted =
            await androidPlugin.requestNotificationsPermission();
        if (!granted!) {
          print('Android notification permission not granted');
        }
      }
    }
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduleTime,
    String payload,
  ) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleTime, tz.local),
        _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('$e');
    }
  }

  final NotificationDetails _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'event_channel',
      'Event Notifications',
      channelDescription: 'This channel is used for event Notification',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(kNotificationSound),
    ),
  );

  // Handle notification taps
  void _handleNotification(NotificationResponse response) {
    ttsService.speak(response.payload!);
  }

  // removing a notification
  Future<void> removeNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      print('$e');
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> pendingNotificationRequest() async {
    try {
      final pendingNotificationsList =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      return pendingNotificationsList;
    } catch (e) {
      throw Exception('$e');
    }
  }
}

void _handleBackGroundNotification(NotificationResponse response) {
  ttsService.speak(response.payload!);
}
