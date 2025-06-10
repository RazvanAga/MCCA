import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_pal/api/firestore_service.dart';
import 'package:kitchen_pal/widgets/empty_state_widget.dart';

class ShoppingListTab extends StatelessWidget {
  ShoppingListTab({super.key});
  final FirestoreService _firestoreService = FirestoreService();

  // Method to show the dialog for adding a new item
  void _showAddItemDialog(BuildContext context) {
    final itemController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item to List'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: itemController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Item Name'),
            validator: (value) => value!.isEmpty ? 'Please enter an item' : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _firestoreService.addItemToShoppingList(itemController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The main widget is now a Scaffold to host the AppBar and FAB
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getShoppingList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              message: 'Your shopping list is empty.',
            );
          }

          final items = snapshot.data!.docs;

          // The content is now a CustomScrollView for a better look
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('Shopping List'),
                floating: true, // App bar appears as you scroll down
                snap: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.playlist_remove_rounded),
                    tooltip: 'Clear Checked Items',
                    onPressed: () {
                      _firestoreService.clearCheckedShoppingItems();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cleared all checked items.')),
                      );
                    },
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = items[index];
                    final data = item.data() as Map<String, dynamic>;
                    final bool isChecked = data['isChecked'] ?? false;
                    final String itemName = data['itemName'] ?? 'No name';

                    // Each item is now dismissible
                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        _firestoreService.deleteIngredient(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"$itemName" removed from list.')),
                        );
                      },
                      background: Container(
                        color: Colors.red.shade400,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
                      ),
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: ListTile(
                          leading: Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              _firestoreService.toggleShoppingItem(item.id, value ?? false);
                            },
                          ),
                          title: Text(
                            itemName,
                            style: TextStyle(
                              decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                              color: isChecked ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: items.length,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}