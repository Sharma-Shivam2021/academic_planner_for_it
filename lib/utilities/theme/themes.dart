import 'package:flutter/material.dart';

class AppTheme {
  static ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.light,
  );

  static ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff6750a4),
    brightness: Brightness.dark,
  );

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
}

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

_inputDecorationTheme() => InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

_bottomSheetTheme(Color bgColor) => BottomSheetThemeData(
      backgroundColor: bgColor,
    );

_elevatedButtonThemeData(Color bgColor) => ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: bgColor,
        iconColor: Colors.white,
        foregroundColor: Colors.white,
      ),
    );
