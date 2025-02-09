import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import "package:flutter/material.dart";
import 'package:share_plus/share_plus.dart';

import '../constants/date_formatter.dart';

void onShare(BuildContext context, Events event) async {
  try {
    String shareText = "${event.eventName} - ${returnDate(event.dateTime)}";
    await Share.share(shareText);
  } catch (e) {
    throw Exception('$e');
  }
}

void onShareFromNotification(String payload) async {
  await Share.share(payload);
}

void onShareMultipleEvents(BuildContext context, List<Events> events) {
  String shareText = events
      .map((e) => "${e.eventName} - ${returnDate(e.dateTime)}")
      .join("\n\n");
  Share.share(shareText);
}
