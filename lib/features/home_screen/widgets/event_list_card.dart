import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import 'package:academic_planner_for_it/utilities/constants/date_formatter.dart';
import 'package:academic_planner_for_it/utilities/services/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/constants/constants.dart';
import '../../../utilities/theme/themes.dart';

class EventListCard extends ConsumerWidget {
  const EventListCard({
    required this.event,
    required this.onDelete,
    super.key,
  });
  final Events event;
  final void Function(Events) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dismissKey = event.eventName + event.dateTime.toString();
    return Dismissible(
      key: Key(dismissKey),
      onDismissed: (dismissDirection) {
        onDelete(event);
      },
      child: Card(
        child: ListTile(
          onTap: () {
            ref.read(ttsProvider).speak(event.eventName);
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
                IconButton(
                  onPressed: () {
                    onDelete(event);
                  },
                  icon: const Icon(
                    Icons.edit_rounded,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: AppTheme.lightScheme.secondary,
                  child: Icon(
                    event.eventNotificationState ==
                            EventNotificationState.created
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
      ),
    );
  }
}
