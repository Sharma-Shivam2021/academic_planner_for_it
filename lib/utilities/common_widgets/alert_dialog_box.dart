import 'package:flutter/material.dart';

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
