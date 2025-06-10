class RecipeIngredient {
  final String name;
  final double quantity;
  final String unit;

  RecipeIngredient({required this.name, required this.quantity, required this.unit});

  factory RecipeIngredient.fromMap(Map<String, dynamic> data) {
    return RecipeIngredient(
      name: data['name'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? '',
    );
  }
}

class Recipe {
  final String id;
  final String title;
  final String description;
  final int prepTime;
  final String imageUrl;
  final List<String> instructions;
  final List<RecipeIngredient> ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.prepTime,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
  });
}