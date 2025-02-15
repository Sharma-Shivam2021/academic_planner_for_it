import 'package:flutter/material.dart';

/// Builds an [AlertDialog] to display an error or exception message.
///
/// This function creates a simple alert dialog with a title, an error message,
/// and an "Okay" button to dismiss the dialog.
///
/// Parameters:
///   - [context]: The [BuildContext] for the dialog.
///   - [errorText]: The [String] containing the error or exception message to display.
///
/// Returns:
///   An [AlertDialog] widget.
AlertDialog buildExceptionAndErrorAlertDialog(
  BuildContext context,
  String errorText,
) {
  return AlertDialog(
    title: const Text('Alert'),
    content: Text(errorText),
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
