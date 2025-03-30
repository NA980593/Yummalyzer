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
    foodDataManager.loadAllEntries().then((entries) {
      setState(() {
        // Call setState to trigger a rebuild
        dates = entries.keys.toList();
        itemsForEachDate.clear(); // Clear the list before adding new items
        for (var item in dates) {
          itemsForEachDate.add(entries[item]);
        }
      });
    });
  }

  List<Widget> _buildChildren() {
    return itemsForEachDate
        .map(
          (item) => ListView.builder(
            itemCount: item.length,
            itemBuilder: (context, i) {
              return Text(item[i]);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body:
          dates.isNotEmpty
              ? ListView.builder(
                itemCount: dates.length,
                itemBuilder: (context, i) {
                  return ExpansionTile(
                    title: Text(dates[i]),
                    subtitle: Text('Trailing expansion arrow icon'),
                    children: _buildChildren(),
                  );
                },
              )
              : Center(child: Text('No Entries Found.')),
    );
  }
}


      // Column(
      //   children: <Widget>[
      //     const ExpansionTile(
      //       title: Text('ExpansionTile 1'),
      //       subtitle: Text('Trailing expansion arrow icon'),
      //       children: <Widget>[ListTile(title: Text('This is tile number 1'))],
      //     ),
      //     ExpansionTile(
      //       title: const Text('ExpansionTile 2'),
      //       subtitle: const Text('Custom expansion arrow icon'),
      //       trailing: Icon(
      //         _customTileExpanded
      //             ? Icons.arrow_drop_down_circle
      //             : Icons.arrow_drop_down,
      //       ),
      //       children: const <Widget>[
      //         ListTile(title: Text('This is tile number 2')),
      //       ],
      //       onExpansionChanged: (bool expanded) {
      //         setState(() {
      //           _customTileExpanded = expanded;
      //         });
      //       },
      //     ),
      //     const ExpansionTile(
      //       title: Text('ExpansionTile 3'),
      //       subtitle: Text('Leading expansion arrow icon'),
      //       controlAffinity: ListTileControlAffinity.leading,
      //       children: <Widget>[ListTile(title: Text('This is tile number 3'))],
      //     ),
      //   ],
      // ),