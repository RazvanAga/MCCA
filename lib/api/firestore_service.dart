import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kitchen_pal/models/recipe.dart';
import 'package:kitchen_pal/models/user_ingredient.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // INVENTORY METHODS
  Stream<List<UserIngredient>> getInventory() {
    if (userId == null) return Stream.value([]);
    return _db.collection('users').doc(userId).collection('inventory').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return UserIngredient(
          id: doc.id,
          name: data['name'],
          quantity: (data['quantity'] ?? 0).toDouble(),
          unit: data['unit'],
        );
      }).toList(),
    );
  }

  Future<void> addOrUpdateIngredient(String name, double quantity, String unit, {String? docId}) {
    if (userId == null) return Future.value();
    final data = {'name': name, 'quantity': quantity, 'unit': unit};
    if (docId != null) {
      return _db.collection('users').doc(userId!).collection('inventory').doc(docId).update(data);
    } else {
      return _db.collection('users').doc(userId!).collection('inventory').add(data);
    }
  }

  Future<void> deleteIngredient(String docId) {
    if (userId == null) return Future.value();
    return _db.collection('users').doc(userId!).collection('inventory').doc(docId).delete();
  }

  // RECIPE METHODS
  Future<List<Recipe>> getRecipes() async {
    final snapshot = await _db.collection('recipes').get();
    final recipes = await Future.wait(snapshot.docs.map((doc) async {
      final data = doc.data();
      final ingredientsSnapshot = await doc.reference.collection('ingredients').get();
      final ingredients = ingredientsSnapshot.docs.map((ingDoc) => RecipeIngredient.fromMap(ingDoc.data())).toList();
      return Recipe(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        prepTime: data['prepTime'] ?? 0,
        imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/400x250.png/CCCCCC/FFFFFF?text=No+Image',
        instructions: List<String>.from(data['instructions'] ?? []),
        ingredients: ingredients,
      );
    }).toList());
    return recipes;
  }

  // SHOPPING LIST METHODS
  Stream<QuerySnapshot> getShoppingList() {
    if (userId == null) return Stream.empty();
    return _db.collection('users').doc(userId!).collection('shoppingList').snapshots();
  }

  Future<void> addItemsToShoppingList(List<String> items) async {
    if (userId == null) return;
    final batch = _db.batch();
    for (var item in items) {
      final docRef = _db.collection('users').doc(userId!).collection('shoppingList').doc();
      batch.set(docRef, {'itemName': item, 'isChecked': false});
    }
    await batch.commit();
  }

  // --- NEW ---
  Future<void> addItemToShoppingList(String itemName) {
    if (userId == null) return Future.value();
    return _db.collection('users').doc(userId!).collection('shoppingList').add({
      'itemName': itemName,
      'isChecked': false,
    });
  }

  // --- NEW ---
  Future<void> clearCheckedShoppingItems() async {
    if (userId == null) return;
    final shoppingListRef = _db.collection('users').doc(userId!).collection('shoppingList');

    final snapshot = await shoppingListRef.where('isChecked', isEqualTo: true).get();

    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void> toggleShoppingItem(String docId, bool isChecked) {
    if (userId == null) return Future.value();
    return _db.collection('users').doc(userId!).collection('shoppingList').doc(docId).update({'isChecked': isChecked});
  }
}