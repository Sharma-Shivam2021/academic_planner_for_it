import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import 'package:academic_planner_for_it/features/home_screen/views/edit_event.dart';
import 'package:academic_planner_for_it/utilities/services/share_event_function.dart';
import 'package:academic_planner_for_it/utilities/constants/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays an [Events] object in a card format for search results.
///
/// This widget shows the event name and date/time of an [Events] object and
/// provides buttons to share or edit the event.
class SearchCard extends ConsumerWidget {
  /// Creates a [SearchCard].
  ///
  /// Parameters:
  ///   - [event]: The [Events] object to display
  const SearchCard({
    required this.event,
    super.key,
  });
  final Events event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
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
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    onShare(context, event);
                  },
                  icon: const Icon(Icons.share),
                );
              }),
              const SizedBox(width: 5),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditEvent(event: event)),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
