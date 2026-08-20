class CategoryModel {
  final int? id;
  final String nom;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    this.id,
    required this.nom,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      nom: json['nom'] ?? '',
      description: json['description'],
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
      'description': description,
      if (createdAt != null)
        'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null)
        'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  CategoryModel copyWith({
    int? id,
    String? nom,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}