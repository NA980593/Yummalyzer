import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:yummalyzer/food_parser.dart';

class FoodDataManager {
  static String formatFoodData(Map<String, String> foodData) {
    final buffer = StringBuffer();
    foodData.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    return buffer.toString();
  }

  static Future<void> saveFoodDataToFile(
    Map<String, String> foodData,
    String filename,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      final formattedData = formatFoodData(foodData);
      await file.writeAsString(formattedData);
      print('Food data saved to: ${file.path}');
    } catch (e) {
      print('Error saving food data: $e');
    }
  }

  static Future<Map<String, String>> loadFoodDataFromFile(
    String filename,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      final fileExists = await file.exists();
      if (fileExists) {
        final fileContent = await file.readAsString();
        return FoodParser.parseFoodString(fileContent);
      } else {
        print('File not found: ${file.path}');
        return {};
      }
    } catch (e) {
      print('Error loading food data: $e');
      return {};
    }
  }
}
