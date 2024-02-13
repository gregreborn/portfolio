import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      hintColor: Colors.teal,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white70),
        // Define other TextStyles for different text elements
      ),
      appBarTheme: AppBarTheme(
        color: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.teal,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.defaultBorderRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstants.defaultBorderRadius),
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstants.defaultBorderRadius),
          borderSide: BorderSide(color: Colors.teal),
        ),
        // Add other stylings for input fields
      ),
      // Define other component themes as needed
    );
  }
}
