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
        temperature: 1,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 65536,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.system(systemInstruction),
    );

    final chat = model.startChat(history: []);

    // Send the image directly as a file
    final response = await chat.sendMessage(
      Content.multiModal([
        DataPart.fromFile(imageFile), // Attach the image file directly
      ]),
    );

    return response.text ?? 'No response from model';
  }
}

/// Calls Gemini API to analyze food from an image file.
Future<String> callGemini(String imagePath) async {
  final apiKey = geminiApiKey;
  final imageFile = File(imagePath);

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

  return await analyzer.analyzeFood(imageFile);
}
