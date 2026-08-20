class NotificationModel {
  final int? id;
  final String titre;
  final String message;
  final String type;
  final bool lu;
  final int? userId;
  final int? budgetId;
  final int? expenseId;
  final DateTime date;
  final DateTime? createdAt;

  NotificationModel({
    this.id,
    required this.titre,
    required this.message,
    required this.type,
    this.lu = false,
    this.userId,
    this.budgetId,
    this.expenseId,
    required this.date,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      titre: json['titre'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      lu: json['lu'] ?? false,
      userId: json['userId'],
      budgetId: json['budgetId'],
      expenseId: json['expenseId'],
      date: DateTime.parse(
        json['date'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titre': titre,
      'message': message,
      'type': type,
      'lu': lu,
      'userId': userId,
      'budgetId': budgetId,
      'expenseId': expenseId,
      'date': date.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    int? id,
    String? titre,
    String? message,
    String? type,
    bool? lu,
    int? userId,
    int? budgetId,
    int? expenseId,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      message: message ?? this.message,
      type: type ?? this.type,
      lu: lu ?? this.lu,
      userId: userId ?? this.userId,
      budgetId: budgetId ?? this.budgetId,
      expenseId: expenseId ?? this.expenseId,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}