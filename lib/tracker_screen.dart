import 'package:flutter/material.dart';
import 'package:yummalyzer/food_data_manager.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key, required this.title});

  final String title;

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  FoodDataManager foodDataManager = FoodDataManager();
  List dates = [];
  List itemsForEachDate = [];
  var x;
  @override
  void initState() {
    super.initState();
    _getDataFromSave();
  }

  _getDataFromSave() {
    foodDataManager.loadAllEntries().then((entries) {
      setState(() {
        // Call setState to trigger a rebuild
        x = entries;
        print(x);
      });
    });
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  x.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                width: double.infinity,
                child: _buildActionButton(
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.arrow_back,
                  label: 'Back',
                ),
              ),
            ),
          ],
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
}
