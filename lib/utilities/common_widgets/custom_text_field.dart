import 'package:flutter/material.dart';

/// A custom text field widget for user input.
///
/// This widget provides a styled [TextField] with customizable properties
/// such as hint text, read-only mode, and an optional tap callback.
class CustomTextField extends StatelessWidget {
  /// Creates a [CustomTextField].
  ///
  /// Parameters:
  ///   - [key]: An optional key to identify this widget.
  ///   - [controller]: The [TextEditingController] for managing the text field's content.
  ///   - [hintText]: The hint text to display when the text field is empty.
  ///   - [onTap]: An optional callback function to be executed when the text field is tapped.
  ///   - [readOnly]: Whether the text field is read-only. Defaults to `false`.
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onTap,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration().copyWith(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
      readOnly: readOnly,
    );
  }
}
