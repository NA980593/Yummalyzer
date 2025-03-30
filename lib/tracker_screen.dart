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
  bool isLoading = true;

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
        isLoading = false;
        print(x);
      });
    });
  }

  // Convert JSON to a readable format without JSON syntax
  Widget formatDataForHumans(dynamic data) {
    if (data == null) {
      return const Text('No data available', 
        style: TextStyle(color: Color(0xffEEEEEE)));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildHumanReadableWidgets(data),
    );
  }
  
  List<Widget> _buildHumanReadableWidgets(dynamic data, {String indent = ''}) {
    List<Widget> widgets = [];
    
    if (data is Map) {
      data.forEach((key, value) {
        if (value is Map || value is List) {
          widgets.add(
            Padding(
              padding: EdgeInsets.only(left: indent.length * 4.0),
              child: Text(
                "$key:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: const Color(0xffEEEEEE),
                ),
              ),
            )
          );
          widgets.addAll(_buildHumanReadableWidgets(value, indent: indent + '  '));
        } else {
          widgets.add(
            Padding(
              padding: EdgeInsets.only(left: indent.length * 4.0, top: 4.0, bottom: 4.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$key: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff00ADB5),
                      ),
                    ),
                    TextSpan(
                      text: value?.toString() ?? 'null',
                      style: TextStyle(
                        color: const Color(0xffEEEEEE),
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        }
      });
    } else if (data is List) {
      for (int i = 0; i < data.length; i++) {
        if (data[i] is Map || data[i] is List) {
          widgets.add(
            Padding(
              padding: EdgeInsets.only(left: indent.length * 4.0, top: 8.0),
              child: Text(
                "Item ${i + 1}:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: const Color(0xffEEEEEE),
                ),
              ),
            )
          );
          widgets.addAll(_buildHumanReadableWidgets(data[i], indent: indent + '  '));
        } else {
          widgets.add(
            Padding(
              padding: EdgeInsets.only(left: indent.length * 4.0, top: 4.0, bottom: 4.0),
              child: Text(
                "• ${data[i]?.toString() ?? 'null'}",
                style: TextStyle(
                  color: const Color(0xffEEEEEE),
                ),
              ),
            )
          );
        }
      };
    } else {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(left: indent.length * 4.0),
          child: Text(
            data?.toString() ?? 'null',
            style: TextStyle(
              color: const Color(0xffEEEEEE),
            ),
          ),
        )
      );
    }
    
    // Add a divider between major sections
    if (indent.isEmpty && widgets.isNotEmpty) {
      widgets.add(const Divider(color: Color(0xff393E46), thickness: 1.0));
    }
    
    return widgets;
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
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xff00ADB5))) 
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: formatDataForHumans(x),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
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