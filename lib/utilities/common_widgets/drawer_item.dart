import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.routeName,
    required this.buttonName,
    this.removeUntilNavigation = false,
  });

  final String routeName;
  final String buttonName;
  final bool removeUntilNavigation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(buttonName),
      onPressed: () {
        !removeUntilNavigation
            ? Navigator.of(context).pushNamed(routeName)
            : Navigator.of(context)
                .pushNamedAndRemoveUntil(routeName, (route) => false);
      },
    );
  }
}
