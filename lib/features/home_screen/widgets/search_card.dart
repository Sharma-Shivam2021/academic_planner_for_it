import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import 'package:academic_planner_for_it/utilities/constants/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/constants/constants.dart';
import '../../../utilities/theme/themes.dart';

class SearchCard extends ConsumerWidget {
  const SearchCard({
    // required this.filteredEvents,
    required this.event,
    super.key,
  });
  final Events event;
  // final List<Events> filteredEvents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        onLongPress: () {
          //Add Share Functionality
        },
        title: Text(
          event.eventName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(dateFormatter(event.dateTime)),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.lightScheme.secondary,
                child: Icon(
                  event.eventNotificationState == EventNotificationState.created
                      ? Icons.notifications
                      : Icons.notifications_off,
                  color: event.eventNotificationState ==
                          EventNotificationState.created
                      ? Colors.red
                      : Colors.green,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
