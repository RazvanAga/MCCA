// lib/screens/ai_chef_screen.dart
import 'package:flutter/material.dart';
import 'package:kitchen_pal/api/firestore_service.dart';
import 'package:kitchen_pal/api/gemini_service.dart';
import 'package:kitchen_pal/models/user_ingredient.dart';

class AiChefScreen extends StatefulWidget {
  const AiChefScreen({super.key});

  @override
  State<AiChefScreen> createState() => _AiChefScreenState();
}

class _AiChefScreenState extends State<AiChefScreen> {
  final _firestoreService = FirestoreService();
  final _geminiService = GeminiService();
  final _promptController = TextEditingController();

  String? _generatedRecipeText;
  bool _isLoading = false;

  void _onGenerateRecipe() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please tell the chef what you want to make!')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _generatedRecipeText = null;
    });

    final List<UserIngredient> inventory = await _firestoreService.getInventory().first;

    // We still call the Gemini service to get the recipe text
    final String response = await _geminiService.generateRecipe(inventory, _promptController.text);

    setState(() {
      _generatedRecipeText = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chef')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "What are you in the mood for?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Tell the AI Chef what you'd like to cook using the ingredients you have.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                hintText: 'e.g., "a quick lunch" or "something with chicken"',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _onGenerateRecipe,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Recipe'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            _buildRecipeResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeResult() {
    if (_isLoading) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Chef is thinking..."),
          ],
        ),
      );
    }

    if (_generatedRecipeText == null) {
      return const Center(child: Text("Your generated recipe will appear here."));
    }

    // --- CHANGE: Display the static robot chef image and the text ---
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // This now shows your local asset image every time!
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.asset(
            'assets/ai_chef_robot.png', // Using the new robot chef image
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _generatedRecipeText!,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}