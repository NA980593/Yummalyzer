import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:yummalyzer/secrets.dart';

/// Converts an image file to a Base64-encoded string
String imageToBase64(File image) {
  final imageBytes = image.readAsBytesSync();
  return base64Encode(imageBytes);
}

class FoodAnalyzer {
  final String apiKey;
  final String modelName;
  final String systemInstruction;

  /// Constructor to initialize the FoodAnalyzer with necessary configurations.
  FoodAnalyzer({
    required this.apiKey,
    this.modelName = 'gemini-2.0-flash',
    required this.systemInstruction,
  });

  /// Analyzes the food in the provided image by sending the Base64-encoded image to the Gemini API.
  Future<String> analyzeFood(String imageBase64) async {
    final model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.text(
        systemInstruction,
      ), // Wrap the systemInstruction into Content.text
    );

    final chat = model.startChat(history: []);

    // Wrap the imageBase64 into the appropriate Content object
    final content = Content.text(
      imageBase64,
    ); // Wrap Base64 string in Content.text

    // Send the wrapped content to the model
    final response = await chat.sendMessage(content);

    return response.text ?? 'No response from model';
  }
}

/// This method will be called to trigger the food analysis.
Future<String> callGemini(File image) async {
  // Use the Gemini API key from secrets.dart
  final apiKey = geminiApiKey;

  // Convert the image file to Base64
  final imageBase64 = imageToBase64(image);

  // Initialize the FoodAnalyzer instance
  final analyzer = FoodAnalyzer(
    apiKey: apiKey,
    systemInstruction: '''
    give me estimated information about the food in this picture in the following format so I can parse it with code. 
    and do not put a space after the colon, do not put quotes, just put the answer itself right after the colon, nothing more. 
    PLEASE make sure the format is in key:value no spaces, no brackets, no commas, no quotes.

    is_food:ANSWER
    name:ANSWER
    calories:ANSWER
    serving_size:ANSWER
    sodium:ANSWER
    cholesterol:ANSWER
    carbs:ANSWER
    protein:ANSWER
    fat:ANSWER
    sugar:ANSWER
    fiber:ANSWER
    iron:ANSWER
    potassium:ANSWER
    calcium:ANSWER
    ''',
  );

  // Analyze the food by sending the Base64-encoded image
  final result = await analyzer.analyzeFood(imageBase64);

  return result; // Return the result as a String
}
