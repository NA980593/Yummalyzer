import 'package:flutter/material.dart';
import 'package:yummalyzer/food_parser.dart';
import 'package:yummalyzer/food_data_manager.dart';
import 'package:yummalyzer/services/food_analyzer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
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
              child: Text('Yummalyze!'),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _getImageFromCamera();
                    },
                    child: Text('Get From Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getImageFromGallery();
                    },
                    child: Text('Get From Gallery'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      updateMap({
                        'name': 'Alice',
                        'age': '30',
                        'city': 'New York',
                      });
                    },
                    child: Text('Assign new map'),
                  ),
                  ElevatedButton(
                    onPressed:
                        _map.entries.isEmpty != true
                            ? () {
                              foodDataManager.saveEntry(_map);
                            }
                            : null,
                    child: Text('Save entry.'),
                  ),
                  ElevatedButton(
                    onPressed:
                        _map.entries.isEmpty != true
                            ? () {
                              foodDataManager.loadAllEntries().then((entries) {
                                print(entries);
                              });
                            }
                            : null,
                    child: Text('Load entry.'),
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
    );
  }
}
