class ExpenseModel {
  final int? id;
  final String titre;
  final double montant;
  final String categorie;
  final DateTime date;
  final String? description;
  final int? budgetId;

  ExpenseModel({
    this.id,
    required this.titre,
    required this.montant,
    required this.categorie,
    required this.date,
    this.description,
    this.budgetId,
  });

  // Depuis JSON (réponse API)
  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      titre: map['titre'] ?? '',
      montant: double.parse(map['montant'].toString()),
      categorie: map['categorie'] ?? '',
      date: DateTime.parse(map['date']),
      description: map['description'],
      budgetId: map['budgetId'],
    );
  }

  // Vers JSON (envoi à l'API)
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'montant': montant,
      'categorie': categorie,
      'date': date.toIso8601String(),
      'description': description,
      'budgetId': budgetId,
    };
  }
}

