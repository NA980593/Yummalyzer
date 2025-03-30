import 'package:flutter/material.dart';
import 'package:yummalyzer/food_parser.dart';
import 'package:yummalyzer/food_data_manager.dart';
import 'package:yummalyzer/services/food_analyzer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:yummalyzer/tracker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, String> _map;

  File? _selectedImage;

  FoodDataManager foodDataManager = FoodDataManager();

  Future<void> _getImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<void> _getImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  @override
  void initState() {
    super.initState();
    _map = {}; // Initialize empty map
  }

  // Method to update the map and trigger a rebuild
  void updateMap(Map<String, String> newMap) {
    setState(() {
      _map = newMap;
    });
  }

  void _goToTrackerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrackerScreen(title: 'Tracker')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222831),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/yummalyzer_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Color(0xff00ADB5),
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children:
                    _map.entries
                        .map((e) => Text("${e.key}: ${e.value}"))
                        .toList(),
              ),
              ElevatedButton(
                onPressed:
                    _selectedImage != null
                        ? () {
                          callGemini(_selectedImage!).then((result) {
                            updateMap(FoodParser.parseFoodString(result));
                          });
                        }
                        : null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff393E46),
                ),

                child: Text(
                  'Yummalyze!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _getImageFromCamera();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff393E46),
                      ),

                      child: Text(
                        'Get From Camera',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _getImageFromGallery();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff393E46),
                      ),

                      child: Text(
                        'Get From Gallery',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _goToTrackerScreen();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff393E46),
                      ),

                      child: Text(
                        'Tracker',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateMap({
                          'name': 'Alice',
                          'age': '30',
                          'city': 'New York',
                        });
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff393E46),
                      ),

                      child: Text(
                        'Assign new map',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed:
                          _map.entries.isEmpty != true
                              ? () {
                                foodDataManager.saveEntry(_map);
                              }
                              : null,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff393E46),
                      ),

                      child: Text(
                        'Save entry.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 200, fit: BoxFit.cover)
                  : const Text("Please get a camera image"),
            ],
          ),
        ),
      ),
    );
  }
}
