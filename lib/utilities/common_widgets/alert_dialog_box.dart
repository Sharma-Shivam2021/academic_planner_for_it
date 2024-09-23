import 'package:flutter/material.dart';

AlertDialog buildAlertDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Alert'),
    content: const Text("Fields should not be empty."),
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
