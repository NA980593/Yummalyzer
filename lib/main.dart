import 'package:flutter/material.dart';
import 'package:yummalyzer/home_screen.dart';
import 'themes/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yummalyzer',
      theme: themes.themeyTitle,
      home: const HomeScreen(title: 'Yummalyzer'),
    );
  }
}
