import '../widgets/search_card.dart';
import 'package:flutter/material.dart';

import '../models/events.dart';

class EventSearchDelegate extends SearchDelegate<Events> {
  final List<Events> allEvents;

  EventSearchDelegate(this.allEvents);

  @override
  String get searchFieldLabel => "Search events...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ''; // clear the search bar
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredList = allEvents
        .where((event) =>
            event.eventName.toLowerCase().contains((query.toLowerCase())))
        .toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return SearchCard(event: filteredList[index]);
      },
    );
  }
}
