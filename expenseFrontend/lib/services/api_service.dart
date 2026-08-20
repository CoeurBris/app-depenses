import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Remplacez par l'URL de votre backend Laravel/Node.js
  static const String baseUrl = 'https://localhost:3000/api'; 

  static Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur lors du chargement des données');
      }
    } catch (e) {
      // Données de secours (Mock) si l'API n'est pas encore connectée
      return {
        'total_budget': 500000.0,
        'total_expenses': 215000.0,
        'remaining_budget': 285000.0,
        'recent_expenses': [
          {'title': 'Courses Alimentaires', 'amount': 25000, 'category': 'Alimentation', 'date': '2026-08-18'},
          {'title': 'Carburant', 'amount': 15000, 'category': 'Transport', 'date': '2026-08-17'},
          {'title': 'Abonnement Internet', 'amount': 30000, 'category': 'Abonnements', 'date': '2026-08-15'},
        ],
        'categories': [
          {'name': 'Alimentation', 'spent': 85000, 'total': 150000},
          {'name': 'Transport', 'spent': 45000, 'total': 80000},
          {'name': 'Loisirs', 'spent': 35000, 'total': 50000},
        ],
      };
    }
  }
}