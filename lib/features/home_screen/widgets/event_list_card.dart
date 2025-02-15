import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import 'package:academic_planner_for_it/features/home_screen/views/edit_event.dart';
import 'package:academic_planner_for_it/utilities/constants/date_formatter.dart';
import 'package:academic_planner_for_it/utilities/services/share_event_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/constants/constants.dart';
import '../../../utilities/theme/themes.dart';

class EventListCard extends ConsumerWidget {
  const EventListCard({
    required this.isSelected,
    required this.isSelectionMode,
    required this.onSelectToggle,
    required this.event,
    required this.onDelete,
    super.key,
  });
  final Events event;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onSelectToggle;
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
            if (isSelectionMode) {
              onSelectToggle();
            } else {
              _buildEvenCardTapBox(context);
            }
          },
          onLongPress: onSelectToggle,
          leading: isSelectionMode
              ? Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    onSelectToggle();
                  })
              : null,
          title: Text(
            event.eventName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(dateFormatter(event.dateTime)),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: CircleAvatar(
              radius: 20,
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
          ),
        ),
      ),
    );
  }

  Future<dynamic> _buildEvenCardTapBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.secondary,
              ),
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _eventInfoAndActionContainer(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Container _eventInfoAndActionContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _textWidget(
              context,
              label: "Event Name: ",
              data: event.eventName,
            ),
            const SizedBox(height: 10),
            _textWidget(
              context,
              label: "Date: ",
              data: returnDate(event.dateTime),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _elevatedButton(context, Icons.edit, "Edit", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditEvent(event: event)),
                  );
                }),
                const SizedBox(height: 10),
                _elevatedButton(context, Icons.share, "Share", () {
                  onShare(context, event);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton _elevatedButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Row _textWidget(BuildContext context,
      {required String label, required String data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          label,
          style: TextStyle(
            overflow: TextOverflow.clip,
            color: Theme.of(context).colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Text(
            data,
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
