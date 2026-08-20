class BudgetModel {
  final int? id;
  final String nom;
  final double montant;
  final double montantDepense;
  final int? categoryId;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String description;
  final bool actif;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  BudgetModel({
    this.id,
    required this.nom,
    required this.montant,
    this.montantDepense = 0,
    this.categoryId,
    required this.dateDebut,
    required this.dateFin,
    this.description = '',
    this.actif = true,
    this.createdAt,
    this.updatedAt,
  });

  // Montant restant du budget
  double get montantRestant{
    return montant - montantDepense;
  }

  // Pourcentage du budget déjà utilisé
  double get pourcentageUtilise{
    if(montant <= 0){
      return 0;
    }
    return (montantDepense / montant) * 100;
  }

  // Vérifie si le budget est dépassé
  bool get estDepasse{
    return montantDepense > montant;
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'],
      nom: json['nom'] ?? '',
      montant: _parseDouble(json['montant']),
      montantDepense: _parseDouble(json['montantDepense']),
      categoryId: json['categoryId'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      description: json['description'],
      actif: json['actif'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nom': nom,
      'montant': montant,
      'montantDepense': montantDepense,
      'categoryId': categoryId,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'description': description,
      'actif': actif,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

   BudgetModel copyWith({
    int? id,
    String? nom,
    double? montant,
    double? montantDepense,
    int? categoryId,
    DateTime? dateDebut,
    DateTime? dateFin,
    String? description,
    bool? actif,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      montant: montant ?? this.montant,
      montantDepense: montantDepense ?? this.montantDepense,
      categoryId: categoryId ?? this.categoryId,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      description: description ?? this.description,
      actif: actif ?? this.actif,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }
}