import 'package:academic_planner_for_it/features/home_screen/views/home_screen.dart';
import 'package:academic_planner_for_it/features/settings_screen/views/settings_screen.dart';
import 'package:academic_planner_for_it/utilities/common_widgets/drawer_item.dart';
import 'package:academic_planner_for_it/features/import_excel/views/import_excel.dart';
import 'package:flutter/material.dart';

/// A custom drawer widget for the application's main navigation.
///
/// This widget provides a side drawer with a header and a list of navigation
/// items, allowing the user to navigate to different screens within the app.
class CustomDrawer extends StatelessWidget {
  /// Creates a [CustomDrawer].
  ///
  /// Parameters:
  ///   - [key]: An optional key to identify this widget.
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  'Academic Planner',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Column(
                  children: [
                    DrawerItem(
                      routeName: HomeScreen.routeName,
                      buttonName: "Home Screen",
                      removeUntilNavigation: true,
                      buttonIcon: Icons.home,
                    ),
                    SizedBox(height: 20),
                    DrawerItem(
                      routeName: ImportExcelScreen.routeName,
                      buttonName: "Import from Excel",
                      buttonIcon: Icons.table_view,
                    ),
                    // SizedBox(height: 20),
                    // DrawerItem(
                    //   routeName: OcrScreen.routeName,
                    //   buttonName: "Upload Image",
                    //   buttonIcon: Icons.image,
                    // ),
                    SizedBox(height: 20),
                    DrawerItem(
                      routeName: SettingsScreen.routeName,
                      buttonName: "Settings",
                      buttonIcon: Icons.settings,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
