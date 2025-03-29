
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:yummalyzer/secrets.dart';

class FoodAnalyzer {
  final String apiKey = geminiApiKey;

  Future<Map<String, dynamic>?> analyzeFood(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    File imageFile = File(image.path);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    String prompt = "give me estimated information about the food in this picture in the following format in a JSON so I can parse it with code:  " +
         " is_food: "
        + " name: "
        + " calories: "
        + " serving_size: "
        + " sodium: "
        + " cholesterol: "
        + " carbs: "
        + " protein: "
        + " fat: "
        + " sugar: "
        + " fiber: "
        + " iron: "
        + " potassium: "
        + " calcium: ";

    Uri url = Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-pro-vision:generateContent?key=$apiKey");

    var requestBody = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Image,
              }
            }
          ]
        }
      ]
    });

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String resultText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];

      try {
        Map<String, dynamic> extractedData = jsonDecode(resultText);
        return extractedData;
      } catch (e) {
        print("Error parsing response: $e");
        return null;
      }
    } else {
      print("Error: ${response.body}");
      return null;
    }
  }
}

