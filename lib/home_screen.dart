import 'package:flutter/material.dart';
import 'package:yummalyzer/food_parser.dart';
import 'package:yummalyzer/food_data_manager.dart';
import 'package:yummalyzer/services/food_analyzer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yummalyzer/tracker_screen.dart';
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
  bool _isAnalyzing = false;
  FoodDataManager foodDataManager = FoodDataManager();

  Future<void> _getImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
      _map = {}; // Clear previous results
    });
  }

  Future<void> _getImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
      _map = {}; // Clear previous results
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
      _isAnalyzing = false;
    });
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final result = await callGemini(_selectedImage!);
      updateMap(FoodParser.parseFoodString(result));
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to analyze image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff222831),
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/yummalyzer_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: const Color(0xff00ADB5),
        centerTitle: true,
        title: Text(
          widget.title,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: const Color(0xffEEEEEE)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Image Card
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: const Color(0xff393E46),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        _selectedImage != null
                            ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(_selectedImage!, fit: BoxFit.cover),
                                if (_isAnalyzing)
                                  Container(
                                    color: Colors.black.withOpacity(0.7),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xff00ADB5),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                            : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 64,
                                    color: const Color(
                                      0xffEEEEEE,
                                    ).withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Select an image to analyze',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 24),

                // Image Selection Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        onPressed: _getImageFromCamera,
                        icon: Icons.camera_alt,
                        label: 'Camera',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        onPressed: _getImageFromGallery,
                        icon: Icons.photo_library,
                        label: 'Gallery',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Analyze Button
                _buildPrimaryButton(
                  context,
                  onPressed:
                      _selectedImage != null && !_isAnalyzing
                          ? _analyzeImage
                          : null,
                  label: 'Yummalyze!',
                  icon: Icons.analytics,
                ),

                const SizedBox(height: 24),

                // Results Section
                if (_map.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff393E46),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analysis Results',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: const Color(0xff00ADB5)),
                        ),
                        const Divider(color: Color(0xff00ADB5), thickness: 1),
                        const SizedBox(height: 8),
                        ..._map.entries
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${entry.key}:',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        entry.value,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                context,
                                onPressed: () {
                                  foodDataManager.saveEntry(_map);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Entry saved successfully!',
                                      ),
                                      backgroundColor: Color(0xff00ADB5),
                                    ),
                                  );
                                },
                                icon: Icons.save,
                                label: 'Save',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildActionButton(
                                context,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              TrackerScreen(title: 'Tracker'),
                                    ),
                                  );
                                },
                                icon: Icons.history,
                                label: 'Tracker',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff393E46),
        foregroundColor: const Color(0xffEEEEEE),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      icon: Icon(icon),
      label: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context, {
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff00ADB5),
        foregroundColor: const Color(0xffEEEEEE),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        disabledBackgroundColor: const Color(0xff00ADB5).withOpacity(0.3),
      ),
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(color: const Color(0xffEEEEEE)),
      ),
    );
  }
}
