// lib/widgets/recipes_tab.dart
import 'package:flutter/material.dart';
import 'package:kitchen_pal/api/firestore_service.dart';
import 'package:kitchen_pal/models/recipe.dart';
import 'package:kitchen_pal/models/user_ingredient.dart';
import 'package:kitchen_pal/screens/ai_chef_screen.dart'; // <-- IMPORT a
import 'package:kitchen_pal/screens/recipe_detail_screen.dart';
import 'package:kitchen_pal/widgets/empty_state_widget.dart';
import 'package:kitchen_pal/widgets/recipe_card_shimmer.dart';

class RecipesTab extends StatefulWidget {
  const RecipesTab({super.key});

  @override
  State<RecipesTab> createState() => _RecipesTabState();
}

class _RecipesTabState extends State<RecipesTab> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<Map<String, dynamic>> _dataFuture;
  int _selectedSegment = 0; // 0 for "Can Make", 1 for "Discover"

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final recipes = await _firestoreService.getRecipes();
    final inventory = await _firestoreService.getInventory().first;
    return {'recipes': recipes, 'inventory': inventory};
  }

  void _refreshData() {
    setState(() {
      _dataFuture = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- CHANGE: WRAP IN SCAFFOLD ---
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const RecipeCardShimmer();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || (snapshot.data!['recipes'] as List<Recipe>).isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.search_off_rounded,
              message: 'No recipes found.\nTry the upload button in the app bar!',
            );
          }

          final allRecipes = snapshot.data!['recipes'] as List<Recipe>;
          final myInventory = snapshot.data!['inventory'] as List<UserIngredient>;
          final myInventoryNames = myInventory.map((i) => i.name.toLowerCase()).toSet();

          final canMakeRecipes = allRecipes.where((recipe) {
            return recipe.ingredients.every((ing) => myInventoryNames.contains(ing.name.toLowerCase()));
          }).toList();

          final discoverRecipes = allRecipes.where((recipe) {
            return !canMakeRecipes.map((r) => r.id).contains(recipe.id);
          }).toList();

          final recipesToShow = _selectedSegment == 0 ? canMakeRecipes : discoverRecipes;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SegmentedButton<int>(
                  segments: const <ButtonSegment<int>>[
                    ButtonSegment<int>(value: 0, label: Text('Can Make'), icon: Icon(Icons.check_circle_outline)),
                    ButtonSegment<int>(value: 1, label: Text('Discover'), icon: Icon(Icons.explore_outlined)),
                  ],
                  selected: {_selectedSegment},
                  onSelectionChanged: (Set<int> newSelection) {
                    setState(() {
                      _selectedSegment = newSelection.first;
                    });
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _refreshData(),
                  child: recipesToShow.isEmpty
                      ? const EmptyStateWidget(
                    icon: Icons.no_food_outlined,
                    message: 'No recipes in this category.',
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recipesToShow.length,
                    itemBuilder: (context, index) {
                      final recipe = recipesToShow[index];
                      return _buildRecipeCard(context, recipe, myInventoryNames);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // --- CHANGE: ADD FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AiChefScreen()),
          );
        },
        label: const Text('AI Chef'),
        icon: const Icon(Icons.auto_awesome_outlined),
        tooltip: 'Generate a recipe with AI',
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe, Set<String> myInventoryNames) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              recipe: recipe,
              myInventoryNames: myInventoryNames,
            ),
          ),
        ).then((_) => _refreshData()); // Refresh when returning
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Image.network(
              recipe.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.restaurant_menu, size: 50, color: Colors.grey)),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.prepTime} mins',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}