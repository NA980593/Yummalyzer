import 'package:flutter/material.dart';
import 'package:yummalyzer/camera_gallery_button.dart';
import 'package:yummalyzer/food_parser.dart';
import 'package:yummalyzer/food_data_manager.dart';
import 'package:yummalyzer/services/food_analyzer.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Map _map;

  @override
  void initState() {
    super.initState();
    _map = {
      "name": "testname",
      "calories": "testcal",
      "serving-size": "testsize",
      "sodium": "testsodium",
      "cholesterol": "testcholesterol",
      "carbs": "testcarbs",
      "protein": "testprotein",
      "fat": "testfat",
      "sugar": "testsugar",
      "fiber": "testfiber",
      "iron": "testiron",
      "potassium": "testpotassium",
      "calcium": "testcalcium",
    }; // Initialize test map
  }

  // Method to update the map and trigger a rebuild
  void updateMap(Map newMap) {
    setState(() {
      _map = newMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150,
              width: 200,
              color: Colors.grey,
              child: CameraGalleryButton(),
            ),
            Column(
              children:
                  _map.entries
                      .map((e) => Text("${e.key}: ${e.value}"))
                      .toList(),
            ),
            ElevatedButton(
              child: Text('Assign Another New Map'),
              onPressed: () {
                print(callGemini(IMAGE_VARIABLE));
              },
            ),
          ],
        ),
      ),
    );
  }
}
