import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api';
  static const String _tokenKey = 'auth_token';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Inscription (Register)
  Future<Map<String, dynamic>> register(
      String nom, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
      if (data['user'] != null) {
        await saveUserData(data['user']['nom'], data['user']['email']);
      }
      return data;
    } else {
      throw Exception(data['message'] ?? 'Erreur lors de l\'inscription');
    }
  }

  /// Connexion (Login)
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
      if (data['user'] != null) {
        await saveUserData(data['user']['nom'], data['user']['email']);
      }
      return data;
    } else {
      throw Exception(data['message'] ?? 'Erreur de connexion');
    }
  }

  /// Stocke le nom et l'email de l'utilisateur
  Future<void> saveUserData(String? name, String? email) async {
    if (name != null) await _storage.write(key: _userNameKey, value: name);
    if (email != null) await _storage.write(key: _userEmailKey, value: email);
  }

  /// Récupère le nom d'affichage
  Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  /// Récupère l'adresse email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// Déconnexion
  Future<void> logout() async {
    await clearToken();
  }

  /// Vérifie si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Récupère le token stocké
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Sauvegarde le token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Supprime le token et les infos utilisateur
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userNameKey);
    await _storage.delete(key: _userEmailKey);
  }
}