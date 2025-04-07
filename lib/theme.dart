import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF8DB38B);
  static const Color primaryColorLight = Color(0xFF9EBF9C);
  static const Color primaryColorDark = Color(0xFF86AE84);
  static const Color secondaryColor = Color(0xFFBB8588);
  static const Color secondaryColorLight = Color(0xFFC49799);
  static const Color secondaryColorDark = Color(0xFFB67C7F);

  // Font Style
  static const TextStyle mainTitle = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 0, 0, 0),
  );

  static const TextStyle secondaryTitle = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle legendTitle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: Colors.black,
  );

  static const TextStyle mainAccentText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle mainText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static const TextStyle legendText = TextStyle(
    fontSize: 12.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    color: Colors.black,
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    secondaryHeaderColor: secondaryColor,
    textTheme: const TextTheme(
        headlineLarge: mainTitle,
        headlineMedium: secondaryTitle,
        headlineSmall: legendTitle,
        bodyLarge: mainAccentText,
        bodyMedium: mainText,
        bodySmall: legendText
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColorLight),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor),
      ),
      labelStyle: const TextStyle(color: Colors.black),
      hintStyle: const TextStyle(color: secondaryColorDark),
      errorStyle: const TextStyle(color: Colors.red),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    secondaryHeaderColor: secondaryColorDark,
    textTheme: TextTheme(
        headlineLarge: mainTitle.copyWith(color: Colors.white),
        headlineMedium: secondaryTitle.copyWith(color: Colors.white),
        headlineSmall: legendTitle.copyWith(color: Colors.white),
        bodyLarge: mainAccentText.copyWith(color: Colors.white),
        bodyMedium: mainText.copyWith(color: Colors.white),
        bodySmall: legendText.copyWith(color: Colors.white)
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColorDark),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor),
      ),
      labelStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: secondaryColorLight),
      errorStyle: const TextStyle(color: Colors.red),
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: primaryColorDark,
      textColor: Colors.white,
    ),
  );
}