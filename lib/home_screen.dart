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
      imageQuality: 85,
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
      imageQuality: 85,
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
      print(FoodParser.parseFoodString(result));
      updateMap(FoodParser.parseFoodString(result));
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to analyze image: $e'),
          backgroundColor: Colors.red[800],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                  child: _selectedImage != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red[400],
                                    size: 50,
                                  ),
                                );
                              },
                            ),
                            if (_isAnalyzing)
                              Container(
                                color: Colors.black.withOpacity(0.7),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Color(0xff00ADB5),
                                        strokeWidth: 6,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Analyzing your food...',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
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
                                color: Colors.white.withOpacity(0.6),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Select an image to analyze',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
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
                    child: _buildImageButton(
                      context,
                      onPressed: _getImageFromCamera,
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      color: const Color(0xff00ADB5),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildImageButton(
                      context,
                      onPressed: _getImageFromGallery,
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      color: const Color(0xff393E46),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Analyze Button
              _buildPrimaryButton(
                context,
                onPressed: _selectedImage != null && !_isAnalyzing
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
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xff00ADB5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(color: Color(0xff00ADB5), thickness: 1),
                      const SizedBox(height: 8),
                      ..._map.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key}:',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff00ADB5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSaveButton(context),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTrackerButton(context),
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
    );
  }

  Widget _buildImageButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
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
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
      ),
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        foodDataManager.saveEntry(_map);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entry saved successfully!'),
            backgroundColor: Color(0xff00ADB5),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff00ADB5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.save),
          SizedBox(width: 8),
          Text('Save'),
        ],
      ),
    );
  }

  Widget _buildTrackerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TrackerScreen(title: 'Tracker'),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff393E46),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history),
          SizedBox(width: 8),
          Text('Tracker'),
        ],
      ),
    );
  }
}