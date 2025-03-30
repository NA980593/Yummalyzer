import 'package:flutter/material.dart';

class FoodUIPopulator extends StatefulWidget {
  final Map initialMap = {};
  @override
  State<FoodUIPopulator> createState() => _FoodUIPopulatorState();
}

class _FoodUIPopulatorState extends State<FoodUIPopulator> {
  late Map _map;

  @override
  void initState() {
    super.initState();
    _map =
        widget.initialMap; // Initialize the map from the widget's initial data
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
      body: Container(
        child: Column(
          children:
              _map.entries.map((e) => Text("${e.key}: ${e.value}")).toList(),
        ),
      ),
    );
  }
}
