import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class FoodDataManager {
  static const String _fileName = 'daily_entries.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<void> saveEntry(Map<String, String> entry) async {
    final file = await _localFile;
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map<String, dynamic> existingData = await _readData();

    if (existingData.containsKey(currentDate)) {
      existingData[currentDate] = [...existingData[currentDate], entry];
    } else {
      existingData[currentDate] = [entry];
    }

    await file.writeAsString(jsonEncode(existingData));
  }

  Future<Map<String, dynamic>> loadAllEntries() async {
    return await _readData();
  }

  Future<List<Map<String, dynamic>>?> loadEntriesForDate(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final data = await _readData();
    return data[formattedDate]?.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> _readData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return jsonDecode(contents) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }
}
