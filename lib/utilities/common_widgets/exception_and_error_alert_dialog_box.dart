import 'package:flutter/material.dart';

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
