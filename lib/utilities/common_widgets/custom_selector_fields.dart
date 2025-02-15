import 'package:flutter/material.dart';

import 'custom_text_field.dart';

/// A custom widget for creating a selectable text field with an associated icon button.
///
/// This widget combines a [CustomTextField] with an [IconButton] to create a
/// field where the user can select a value, typically by tapping the icon button,
/// which then populates the text field.
class CustomSelectorFields extends StatelessWidget {
  /// Creates a [CustomSelectorFields].
  ///
  /// Parameters:
  ///   - [key]: An optional key to identify this widget.
  ///   - [controller]: The [TextEditingController] for managing the text field's content.
  ///   - [onTap]: A callback function to be executed when the text field or the icon button is tapped.
  ///   - [hintText]: The hint text to display when the text field is empty.
  ///   - [icon]: The icon to display in the icon button.
  const CustomSelectorFields({
    super.key,
    required this.controller,
    required this.onTap,
    required this.hintText,
    required this.icon,
  });
  final TextEditingController controller;
  final VoidCallback onTap;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: controller,
            hintText: hintText,
            onTap: onTap,
            readOnly: true,
          ),
        ),
        IconButton(
          onPressed: onTap,
          icon: Icon(icon),
        )
      ],
    );
  }
}
