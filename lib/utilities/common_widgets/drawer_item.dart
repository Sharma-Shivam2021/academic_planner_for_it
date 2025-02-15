import 'package:flutter/material.dart';

/// A custom widget for creating a navigation button within a drawer.
///
/// This widget is designed to be used within a drawer to navigate to different
/// screens in the application. It displays an icon and a text label, and
/// handles navigation when pressed.
class DrawerItem extends StatelessWidget {
  /// Creates a [DrawerItem].
  ///
  /// Parameters:
  ///- [key]: An optional key to identify this widget.
  ///   - [routeName]: The name of the route to navigate to when pressed.
  ///   - [buttonName]: The text label to display on the button.
  ///   - [removeUntilNavigation]: Whether to remove all previous routes from the
  ///     navigation stack when navigating. Defaults to `false`.
  ///   - [buttonIcon]: The icon to display on the button.
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
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, 50),
        alignment: AlignmentDirectional.centerStart,
      ),
    );
  }
}
