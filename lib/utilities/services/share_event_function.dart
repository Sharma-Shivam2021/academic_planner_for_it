import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import "package:flutter/material.dart";
import 'package:share_plus/share_plus.dart';

void onShare(BuildContext context, Events event) async {
  try {
    String shareText =
        "${event.eventName} on ${event.dateTime.day}/${event.dateTime.month}/${event.dateTime.year}";
    await Share.share(shareText);
  } catch (e) {
    throw Exception('$e');
  }
}

void onShareFromNotification(String payload) async {
  await Share.share(payload);
}
