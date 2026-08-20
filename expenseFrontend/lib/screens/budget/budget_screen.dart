import 'package:flutter/material.dart';
import 'add_budget_screen.dart';
import 'edit_budget_screen.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Budgets')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBudgetScreen())),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text('Budget Mensuel ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Alimentation • 150,000 FCFA'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditBudgetScreen())),
              ),
            ),
          );
        },
      ),
    );
  }
}