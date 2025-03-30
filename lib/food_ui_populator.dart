import 'package:flutter/material.dart';

class FoodUIPopulator extends StatelessWidget {
  final Map map;

  const FoodUIPopulator(Key key, this.map) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children:
              map.entries.map((e) => Text("${e.key}: ${e.value}")).toList(),
        ),
      ),
    );
  }
}
