import 'package:flutter/material.dart';


class AppTheme {
  static const primaryColor = Color(0xff1F312B);
  static const secondaryColor = Color(0xff37241A);
  static const accentColor = Color(0xffDDBE80);
  static const surfaceColor = Color(0xff232C26);
  static const onSuerfaceColor = Colors.white;

  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        onSurface: surfaceColor,
      ),
      scaffoldBackgroundColor: accentColor,
      cardColor: surfaceColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff135433),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
          )
        ) ,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        )
    );
  }
  
}