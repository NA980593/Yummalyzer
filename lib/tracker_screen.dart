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
  @override
  void initState() {
    super.initState();
    _getDataFromSave();
  }

  _getDataFromSave() {
    var x;
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
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Text('x'),
    );
  }
}
