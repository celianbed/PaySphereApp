import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String apiUrl = "http://ton-serveur.com/api/login"; // URL de l'API Flask

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)); // Conversion JSON → Objet User
    } else {
      return null;
    }
  }
}
