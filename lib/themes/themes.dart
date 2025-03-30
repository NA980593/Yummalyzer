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
      iconTheme: IconThemeData(color: Colors.orangeAccent),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static ThemeData themeyButtons = ThemeData(
    fontFamily: 'Germagont',
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Germagont',
        fontSize: 16.0,
      ),
      
      bodyMedium: TextStyle(
        fontFamily: 'Germagont',
        fontSize: 14.0,
      ),

      headlineLarge: TextStyle(
        fontFamily: 'Germagont',
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
      iconTheme: IconThemeData(color: Colors.orangeAccent),
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