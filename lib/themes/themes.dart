import 'package:flutter/material.dart';

class themes {
  static ThemeData themeyTitle = ThemeData(
    fontFamily: 'Happy Chicken',
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Happy Chicken',
        fontSize: 16.0,
      ),
      
      bodyMedium: TextStyle(
        fontFamily: 'Germagont',
        fontSize: 18.0,
        color: Color(0xffEEEEEE)
      ),

      headlineLarge: TextStyle(
        fontFamily: 'Happy Chicken',
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),

      headlineMedium: TextStyle(
        fontFamily: 'Germagont',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),

    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Color(0xff00ADB5)),
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