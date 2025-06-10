// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:kitchen_pal/api/firestore_service.dart';
import 'package:kitchen_pal/models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final Set<String> myInventoryNames;
  final FirestoreService _firestoreService = FirestoreService();

  RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.myInventoryNames,
  });

  @override
  Widget build(BuildContext context) {
    final missingIngredients = recipe.ingredients
        .where((ing) => !myInventoryNames.contains(ing.name.toLowerCase()))
        .map((ing) => ing.name)
        .toList();

    // --- UI UPGRADE: DYNAMIC SCROLLING USING SLIVERS ---
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.title,
                style: const TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 8)]),
              ),
              background: Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, size: 100)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.description,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, 'Ingredients'),
                      const Divider(),
                      ...recipe.ingredients.map((ing) {
                        final haveIt = myInventoryNames.contains(ing.name.toLowerCase());
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            haveIt ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: haveIt ? Theme.of(context).colorScheme.primary : Colors.grey,
                          ),
                          title: Text(
                            '${ing.name} - ${ing.quantity.toStringAsFixed(0)} ${ing.unit}',
                            style: TextStyle(
                              color: haveIt ? Colors.black87 : Colors.grey.shade600,
                            ),
                          ),
                        );
                      }).toList(),
                      if (missingIngredients.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add_shopping_cart_outlined),
                            label: const Text('Add Missing to Shopping List'),
                            onPressed: () {
                              _firestoreService.addItemsToShoppingList(missingIngredients);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${missingIngredients.length} items added.')),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, 'Instructions'),
                      const Divider(),
                      ...recipe.instructions.asMap().entries.map((entry) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          child: Text('${entry.key + 1}'),
                        ),
                        title: Text(entry.value),
                      )).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}