import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.routeName,
    required this.buttonName,
    this.removeUntilNavigation = false,
    required this.buttonIcon,
  });

  final String routeName;
  final String buttonName;
  final bool removeUntilNavigation;
  final IconData buttonIcon;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ElevatedButton.icon(
      icon: Icon(buttonIcon),
      label: Text(
        buttonName,
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: () {
        !removeUntilNavigation
            ? Navigator.of(context).pushNamed(routeName)
            : Navigator.of(context)
                .pushNamedAndRemoveUntil(routeName, (route) => false);
      },
      style: ElevatedButton.styleFrom(minimumSize: Size(width, 50)),
    );
  }
}
