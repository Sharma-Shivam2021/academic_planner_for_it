import 'package:academic_planner_for_it/utilities/services/share_event_function.dart';
import 'package:academic_planner_for_it/utilities/services/tts_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// An instance of [TTSService] for text-to-speech functionality.
final TTSService ttsService = TTSService();

/// A service class for managing local notifications.
///
/// This class uses the `flutter_local_notifications` package to provide
/// notification capabilities.
class NotificationServices {
  /// The [FlutterLocalNotificationsPlugin] instance used for managing notifications.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service.
  ///
  /// This method initializes the time zones,sets up the notification channels,
  /// and requests notification permissions.
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

  /// Requests notification permissions from the user.
  ///
  /// This method specifically requests permissions for Android devices.
  ///
  /// Throws an exception if the user denies the notification permission.
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
          throw Exception('Android notification permission not granted');
        }
      }
    }
  }

  /// Schedules a local notification to be displayed at a specific time.
  ///
  /// Parameters:
  ///   - [id]: The unique ID for the notification.
  ///   - [title]: The title of the notification.
  ///   - [body]: The body text of the notification.
  ///   - [scheduleTime]: The [DateTime] when the notification should be displayed.
  ///   - [payload]: The payload data associated with the notification.
  ///
  /// Throws an exception if there is an error scheduling the notification.
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
        payload: payload,
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// The default notification details for Android.
  final NotificationDetails _notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      'event_channel',
      'Event Notifications',
      channelDescription: 'This channel is used for event Notification',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('new_event_female'),
      actions: [
        AndroidNotificationAction(
          'shareId',
          'Share',
          showsUserInterface: true,
        ),
      ],
    ),
  );

  /// Handles notification taps when the app is in the foreground.
  ///
  /// Parameters:
  ///   - [response]: The [NotificationResponse] object containing the notification details.
  void _handleNotification(NotificationResponse response) {
    handleNotificationAction(response);
  }

  /// Removes a specific notification.
  ///
  /// Parameters:
  ///   - [id]: The ID of the notification to remove.
  ///
  /// Throws an exception if there is an error removing the notification.
  Future<void> removeNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Cancels all scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Retrieves a list of pending notification requests.
  ///
  /// Returns:
  ///   A [List] of [PendingNotificationRequest] objects.
  ///
  /// Throws an exception if there is an error retrieving the pending notifications.
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

/// Handles notification taps when the app is in the background.
///
/// Parameters:
///   - [response]: The [NotificationResponse] object containing the notification details.
void _handleBackGroundNotification(NotificationResponse response) {
  handleNotificationAction(response);
}

/// Handles the action associated with a notification tap.
///
/// If the notification action is 'shareId', it shares the notification payload.
/// Otherwise, it uses the [TTSService] to speak the notification payload.
///
/// Parameters:
///   - [response]: The [NotificationResponse] object containing the notification details.
void handleNotificationAction(NotificationResponse response) {
  if (response.actionId == 'shareId') {
    onShareFromNotification(response.payload!);
  } else {
    ttsService.speak(response.payload!);
  }
}
