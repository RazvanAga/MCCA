// lib/api/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kitchen_pal/models/user_ingredient.dart';
import 'package:kitchen_pal/api/api_keys.dart';

class GeminiService {
  static const String _apiKey = geminiApiKey;

  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: _apiKey,
  );

  Future<String> generateRecipe(List<UserIngredient> ingredients, String userPrompt) async {
    final ingredientList = ingredients.map((i) => '${i.name} (${i.quantity.toStringAsFixed(0)} ${i.unit})').join(', ');

    // --- UPGRADED, STRICTER PROMPT ---
    final prompt = """
      You are a helpful chef. A user wants a recipe.
      Your entire response MUST strictly follow the format below. Do not add any extra text, introductions, or closing remarks. Do not use markdown like asterisks or bolding. The first line of your response must start with "TITLE:".

      AVAILABLE INGREDIENTS:
      $ingredientList

      USER'S REQUEST:
      "$userPrompt"

      THE REQUIRED OUTPUT FORMAT:
      TITLE: [Your Recipe Title Here]
      DESCRIPTION: [A short, enticing description of the dish.]
      INGREDIENTS:
      - [Quantity] [Unit] [Ingredient Name]
      - [Quantity] [Unit] [Ingredient Name]
      INSTRUCTIONS:
      1. [First step of the instruction]
      2. [Second step of the instruction]
      3. [And so on...]
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        return response.text!;
      } else {
        return "TITLE: Error\nDESCRIPTION: Sorry, I couldn't generate a recipe right now. Please try again.";
      }
    } catch (e) {
      print("Error generating recipe: $e");
      return "TITLE: Error\nDESCRIPTION: An error occurred while talking to the AI Chef. Please check your connection and API key.";
    }
  }
}