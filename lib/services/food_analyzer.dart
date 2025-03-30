import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:yummalyzer/secrets.dart';

class FoodAnalyzer {
  final String apiKey;
  final String modelName;
  final String systemInstruction;

  FoodAnalyzer({
    required this.apiKey,
    this.modelName = 'gemini-2.5-pro-exp-03-25',
    required this.systemInstruction,
  });

  /// Analyzes the food in the provided image file by sending it directly to the Gemini API.
  Future<String> analyzeFood(File imageFile) async {
    final model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 65536,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.text(systemInstruction),
    );

    final chat = model.startChat(history: []);

    // Read the image file as bytes
    final imageBytes = imageFile.readAsBytesSync();
    final imagePart = DataPart('image/jpeg', imageBytes); // Correct image format

    // Send the image directly
    final response = await chat.sendMessage(
      Content.multi([imagePart]), // Corrected method
    );

    return response.text ?? 'No response from model';
  }
}

/// Calls Gemini API to analyze food from an image.
/// Accepts either a `String` (file path) or a `File` object.
Future<String> callGemini(dynamic imageInput) async {
  final apiKey = geminiApiKey;

  // Ensure the input is a File object
  File imageFile;
  if (imageInput is File) {
    imageFile = imageInput; // Already a File
  } else if (imageInput is String) {
    imageFile = File(imageInput); // Convert path to File
  } else {
    throw ArgumentError('Invalid image input. Must be a File or a String (file path).');
  }

  final analyzer = FoodAnalyzer(
    apiKey: apiKey,
    systemInstruction: '''
    give me estimated information about the food in this picture in the following format so I can parse it with code. and do not put a space after the colon, do not put quotes, just put the answer itself right after the colon, nothing more. 
    PLEASE make sure the format is in key:value no spaces, no brackets, no commas, no quotes. Include in the notes section things such as possible allergens, if the item is either healthy, not healthy, or moderately healthy, if the item item is highly processed, 
    moderatly processed, or lightly/not processed, if there is a high sodium count, or if there is a high sugar count. If it is not healthy, suggest a similar but healthier alternative.

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
    Notes:ANSWER
    ''',
  );

  return await analyzer.analyzeFood(imageFile);
}
