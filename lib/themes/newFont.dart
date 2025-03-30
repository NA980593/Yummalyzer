import 'package:flutter/material.dart';

class newFont {
  static ThemeData themey = ThemeData(
    fontFamily: 'Happy Chicken',
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Happy Chicken',
        fontSize: 16.0,
      ),
      
      bodyMedium: TextStyle(
        fontFamily: 'Happy Chicken',
        fontSize: 14.0,
      ),

      headlineLarge: TextStyle(
        fontFamily: 'Happy Chicken',
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),

      headlineMedium: TextStyle(
        fontFamily: 'Happy Chicken',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),

    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.blueAccent),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    ),
  );
}