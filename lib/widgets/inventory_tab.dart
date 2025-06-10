// lib/widgets/inventory_tab.dart
import 'package:flutter/material.dart';
import 'package:kitchen_pal/api/firestore_service.dart';
import 'package:kitchen_pal/models/user_ingredient.dart';
import 'package:kitchen_pal/widgets/empty_state_widget.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  final FirestoreService _firestoreService = FirestoreService();

  void _showIngredientDialog({UserIngredient? ingredient}) {
    final nameController = TextEditingController(text: ingredient?.name);
    final quantityController = TextEditingController(text: ingredient?.quantity.toStringAsFixed(0));
    final unitController = TextEditingController(text: ingredient?.unit);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(ingredient == null ? 'Add Ingredient' : 'Edit Ingredient'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Ingredient Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter a quantity' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: unitController,
                  decoration: const InputDecoration(labelText: 'Unit (e.g., g, pcs, ml)'),
                  validator: (value) => value!.isEmpty ? 'Please enter a unit' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _firestoreService.addOrUpdateIngredient(
                    nameController.text,
                    double.parse(quantityController.text),
                    unitController.text,
                    docId: ingredient?.id,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<UserIngredient>>(
        stream: _firestoreService.getInventory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.kitchen_outlined,
              message: 'Your kitchen is empty.\nTap the + button to add ingredients!',
            );
          }

          final ingredients = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];

              // --- CHANGE: WRAP THE CARD IN A DISMISSIBLE WIDGET ---
              return Dismissible(
                // A unique key is required for each item in the list
                key: Key(ingredient.id),

                // We only want to swipe from right to left (end to start)
                direction: DismissDirection.endToStart,

                // This function is called after the item has been swiped away
                onDismissed: (direction) {
                  // Call our Firestore service to delete the document
                  _firestoreService.deleteIngredient(ingredient.id);

                  // Show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('"${ingredient.name}" deleted from your kitchen.')),
                  );
                },

                // This is the background that appears behind the item as you swipe
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
                ),

                // The actual widget that the user sees and swipes
                child: Card(
                  child: ListTile(
                    title: Text(ingredient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text('${ingredient.quantity.toStringAsFixed(0)} ${ingredient.unit}'),
                    onTap: () => _showIngredientDialog(ingredient: ingredient),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showIngredientDialog(),
        tooltip: 'Add Ingredient',
        child: const Icon(Icons.add),
      ),
    );
  }
}