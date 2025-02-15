import 'package:flutter/material.dart';

/// Builds a simple [AlertDialog] with a title, content, and an "Okay" button.
///
/// This function creates an alert dialog that displays a given title and
/// content. It includes a single "Okay" button that, when pressed, dismisses
/// the dialog.
///
/// Parameters:
///   - [context]: The [BuildContext] for the dialog.
///   - [title]: The [String] to display as the title of the dialog.
///   - [content]: The [String] to display as the content of the dialog.
///
/// Returns:
///   An [AlertDialog] widget.
AlertDialog buildAlertDialog(
    BuildContext context, String title, String content) {
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Okay'),
      )
    ],
  );
}
