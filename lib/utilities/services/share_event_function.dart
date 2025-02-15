import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import "package:flutter/material.dart";
import 'package:share_plus/share_plus.dart';

import '../constants/date_formatter.dart';

/// Shares the details of a single event.
///
/// This function takes an [Events] object and shares its name and date/time
/// using the `share_plus` package.
///
/// Parameters:
///   - [context]: The build context.
///   - [event]: The [Events] object to share.
///
/// Throws an exception if there is an error during the sharing process.
void onShare(BuildContext context, Events event) async {
  try {
    String shareText = "${event.eventName} - ${returnDate(event.dateTime)}";
    await Share.share(shareText);
  } catch (e) {
    throw Exception('$e');
  }
}

/// Shares a text payload received from a notification.
///
/// This function is designed to share text content that is passed as a payload
/// from a notification.
///
/// Parameters:
///   - [payload]: The text payload to share.
void onShareFromNotification(String payload) async {
  await Share.share(payload);
}

/// Shares the details of multiple events.
///
/// This function takes a list of [Events] objects and shares their names and
/// date/times, formatted as a single string with each event on a new line.
///
/// Parameters:
///   - [context]: The build context.
///   - [events]: The list of [Events] objects to share.
void onShareMultipleEvents(BuildContext context, List<Events> events) {
  String shareText = events
      .map((e) => "${e.eventName} - ${returnDate(e.dateTime)}")
      .join("\n\n");
  Share.share(shareText);
}
