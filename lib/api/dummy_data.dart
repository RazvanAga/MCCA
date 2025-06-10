// lib/api/dummy_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DummyDataService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> uploadDummyRecipes() async {
    final recipesCollection = _db.collection('recipes');
    final query = await recipesCollection.limit(1).get();

    if (query.docs.isNotEmpty) {
      print("Recipes collection is not empty. Skipping upload.");
      return;
    }

    print("Uploading a fresh set of dummy recipes...");

    final recipes = [
      {
        'title': 'Classic Spaghetti Carbonara',
        'description': 'A creamy and delicious Italian pasta classic perfect for a quick dinner.',
        'prepTime': 20,
        'imageUrl': 'https://www.177milkstreet.com/assets/site/Recipes/_large/Skillet-Spaghetti-alla-Carbonara.jpg', // <-- UPDATED IMAGE URL
        'instructions': [
          'Boil pasta according to package directions.',
          'Meanwhile, cook pancetta in a large skillet until crisp.',
          'In a bowl, whisk eggs, cheese, and a generous amount of black pepper.',
          'Drain pasta, reserving about a cup of pasta water. Add pasta to skillet with pancetta.',
          'Remove from heat, quickly stir in egg mixture, adding splashes of pasta water to create a creamy, non-scrambled sauce.'
        ],
        'ingredients': [
          {'name': 'Spaghetti', 'quantity': 400, 'unit': 'g'},
          {'name': 'Pancetta', 'quantity': 150, 'unit': 'g'},
          {'name': 'Eggs', 'quantity': 4, 'unit': 'pcs'},
          {'name': 'Parmesan Cheese', 'quantity': 50, 'unit': 'g'},
          {'name': 'Black Pepper', 'quantity': 1, 'unit': 'tsp'},
        ]
      },
      {
        'title': 'Chicken & Veggie Stir-fry',
        'description': 'A quick, healthy, and colorful stir-fry that is easily customizable.',
        'prepTime': 25,
        'imageUrl': 'https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2021/05/Chicken-Stir-Fry-main.jpg', // <-- UPDATED IMAGE URL
        'instructions': [
          'Cut chicken and vegetables into bite-sized pieces.',
          'Heat oil in a wok or large skillet over high heat.',
          'Stir-fry chicken until cooked through. Remove from skillet.',
          'Add vegetables (starting with harder ones like broccoli) and stir-fry until tender-crisp.',
          'Return chicken to skillet, add stir-fry sauce, and toss to combine. Serve immediately with rice.'
        ],
        'ingredients': [
          {'name': 'Chicken Breast', 'quantity': 2, 'unit': 'pcs'},
          {'name': 'Broccoli', 'quantity': 1, 'unit': 'head'},
          {'name': 'Bell Pepper', 'quantity': 1, 'unit': 'pcs'},
          {'name': 'Onion', 'quantity': 1, 'unit': 'pcs'},
          {'name': 'Soy Sauce', 'quantity': 4, 'unit': 'tbsp'},
        ]
      },
      {
        'title': 'Fluffy Buttermilk Pancakes',
        'description': 'The classic breakfast favorite, with crispy edges and a soft center.',
        'prepTime': 15,
        'imageUrl': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?q=80&w=1980&auto=format&fit=crop', // (This one was not changed)
        'instructions': [
          'In a large bowl, whisk together flour, sugar, baking powder, baking soda, and salt.',
          'In a separate bowl, whisk together buttermilk, egg, and melted butter.',
          'Pour the wet ingredients into the dry ingredients and stir until just combined. Do not overmix!',
          'Heat a lightly oiled griddle or frying pan over medium-high heat.',
          'Pour or scoop the batter onto the griddle, using approximately 1/4 cup for each pancake.',
          'Cook until bubbles appear on the surface, then flip and cook until golden brown.'
        ],
        'ingredients': [
          {'name': 'Flour', 'quantity': 2, 'unit': 'cups'},
          {'name': 'Sugar', 'quantity': 2, 'unit': 'tbsp'},
          {'name': 'Baking Powder', 'quantity': 2, 'unit': 'tsp'},
          {'name': 'Egg', 'quantity': 1, 'unit': 'pcs'},
          {'name': 'Milk', 'quantity': 2, 'unit': 'cups'},
          {'name': 'Butter', 'quantity': 2, 'unit': 'tbsp'},
        ]
      },
      {
        'title': 'Creamy Tomato Soup & Grilled Cheese',
        'description': 'The ultimate comfort food duo for a rainy day or a quick, satisfying meal.',
        'prepTime': 20,
        'imageUrl': 'https://simply-delicious-food.com/wp-content/uploads/2019/08/Tomato-soup-with-grilled-cheese-5.jpg', // <-- UPDATED IMAGE URL
        'instructions': [
          'Melt butter in a large pot. Add chopped onion and garlic and cook until soft.',
          'Stir in canned tomatoes, vegetable broth, and sugar. Season with salt and pepper.',
          'Bring to a simmer and cook for 10 minutes. Use an immersion blender to blend until smooth.',
          'Stir in heavy cream and heat through.',
          'To make the grilled cheese, butter one side of each bread slice. Place one slice butter-side-down, top with cheese, and the other slice butter-side-up.',
          'Grill in a non-stick skillet until golden brown on both sides and cheese is melted.'
        ],
        'ingredients': [
          {'name': 'Onion', 'quantity': 1, 'unit': 'pcs'},
          {'name': 'Garlic', 'quantity': 2, 'unit': 'cloves'},
          {'name': 'Canned Tomatoes', 'quantity': 800, 'unit': 'g'},
          {'name': 'Bread', 'quantity': 4, 'unit': 'slices'},
          {'name': 'Cheese', 'quantity': 4, 'unit': 'slices'},
          {'name': 'Butter', 'quantity': 3, 'unit': 'tbsp'},
        ]
      },
      {
        'title': 'Classic Ground Beef Tacos',
        'description': 'A fun and easy weeknight dinner that everyone in the family can customize.',
        'prepTime': 25,
        'imageUrl': 'https://www.onceuponachef.com/images/2023/08/Beef-Tacos.jpg', // <-- UPDATED IMAGE URL
        'instructions': [
          'In a large skillet, cook ground beef over medium-high heat until no longer pink. Drain excess fat.',
          'Stir in taco seasoning and water according to package directions. Simmer for 5 minutes.',
          'While the meat simmers, warm taco shells in the oven as directed.',
          'Prepare toppings: chop lettuce and tomatoes, and shred cheese.',
          'Serve the seasoned beef, warm shells, and toppings separately so everyone can build their own tacos.'
        ],
        'ingredients': [
          {'name': 'Ground Beef', 'quantity': 500, 'unit': 'g'},
          {'name': 'Taco Seasoning', 'quantity': 1, 'unit': 'packet'},
          {'name': 'Taco Shells', 'quantity': 12, 'unit': 'pcs'},
          {'name': 'Lettuce', 'quantity': 1, 'unit': 'head'},
          {'name': 'Tomato', 'quantity': 2, 'unit': 'pcs'},
          {'name': 'Cheddar Cheese', 'quantity': 1, 'unit': 'cup'},
        ]
      },
    ];

    for (var recipeData in recipes) {
      final ingredients = recipeData.remove('ingredients') as List<Map<String, dynamic>>;
      final docRef = await recipesCollection.add(recipeData);
      for (var ingredient in ingredients) {
        await docRef.collection('ingredients').add(ingredient);
      }
    }
    print("Dummy recipes uploaded successfully.");
  }
}