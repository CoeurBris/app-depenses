import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toutes les Dépenses')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen())),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.arrow_downward, color: Colors.white),
              ),
              title: Text('Achat Épicerie ${index + 1}'),
              subtitle: const Text('Alimentation • Aujourd\'hui'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '-${(index + 1) * 2500} FCFA',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditExpenseScreen())),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}