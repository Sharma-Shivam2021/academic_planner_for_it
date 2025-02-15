import 'package:flutter/material.dart';

/// A class that defines the application's themes, including light and dark modes.class AppTheme {
class AppTheme {
  /// The color scheme for the light theme.
  static ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.light,
  );

  /// The color scheme for the dark theme.
  static ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff6750a4),
    brightness: Brightness.dark,
  );

  /// The light theme data for the application.
  static final lightMode = ThemeData.light().copyWith(
    colorScheme: lightScheme,
    scaffoldBackgroundColor: lightScheme.primaryContainer,
    appBarTheme: _appBarTheme(
      lightScheme.primary,
      lightScheme.onPrimary,
      lightScheme.primaryContainer,
      lightScheme.onTertiaryContainer,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightScheme.primary,
    ),
    inputDecorationTheme: _inputDecorationTheme(),
    bottomSheetTheme: _bottomSheetTheme(lightScheme.primaryContainer),
    elevatedButtonTheme: _elevatedButtonThemeData(lightScheme.primary),
    cardTheme: CardTheme(
      color: lightScheme.secondaryContainer,
    ),
  );

  /// The dark theme data for the application.
  static final darkMode = ThemeData.dark().copyWith(
    colorScheme: darkScheme,
    scaffoldBackgroundColor: darkScheme.primaryContainer,
    appBarTheme: _appBarTheme(
      darkScheme.onPrimary,
      darkScheme.onPrimaryContainer,
      darkScheme.secondary,
      darkScheme.onTertiaryContainer,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkScheme.onPrimaryFixed,
    ),
    inputDecorationTheme: _inputDecorationTheme(),
    bottomSheetTheme: _bottomSheetTheme(darkScheme.secondaryContainer),
    elevatedButtonTheme: _elevatedButtonThemeData(darkScheme.onPrimary),
    cardTheme: CardTheme(
      color: darkScheme.secondaryContainer,
    ),
  );
}

/// Configures the [AppBarTheme] with the specified colors.
///
/// Parameters:
///   - [bgColor]: The background color of the app bar.
///   - [titleTextColor]: The text color of the app bar title.
///   - [actionIconColor]: The color of the action icons in the app bar.
///   - [iconColor]: The color of the leading icon in the app bar.
_appBarTheme(
  Color bgColor,
  Color titleTextColor,
  Color actionIconColor,
  Color iconColor,
) =>
    AppBarTheme(
        color: bgColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: titleTextColor,
          fontSize: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: actionIconColor,
          size: 25,
        ),
        iconTheme: IconThemeData(
          color: iconColor,
        ));

/// Configures the [InputDecorationTheme] for the application.
_inputDecorationTheme() => InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

/// Configures the [BottomSheetThemeData] with the specified background color.
///
/// Parameters:
///   - [bgColor]: The background color of the bottom sheet.
_bottomSheetTheme(Color bgColor) => BottomSheetThemeData(
      backgroundColor: bgColor,
    );

/// Configures the [ElevatedButtonThemeData] with the specified background color.
///
/// Parameters:
///   - [bgColor]: The background color of the elevated button.
_elevatedButtonThemeData(Color bgColor) => ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: bgColor,
        iconColor: Colors.white,
        foregroundColor: Colors.white,
      ),
    );
