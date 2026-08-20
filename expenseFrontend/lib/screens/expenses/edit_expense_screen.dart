import 'package:flutter/material.dart';

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({super.key});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Achat Épicerie');
    _amountController = TextEditingController(text: '5000');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la Dépense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre / Libellé', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Titre requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Montant (FCFA)', border: OutlineInputBorder()),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Montant invalide' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                child: const Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}