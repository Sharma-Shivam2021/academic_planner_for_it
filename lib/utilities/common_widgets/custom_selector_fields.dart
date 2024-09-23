import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class CustomSelectorFields extends StatelessWidget {
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
