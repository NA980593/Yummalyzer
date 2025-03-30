import 'package:flutter/material.dart';
import 'package:yummalyzer/home_screen.dart';
import 'themes/newFont.dart';

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
      theme: newFont.themey,
      home: const HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
