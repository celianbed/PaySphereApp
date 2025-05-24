import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static String get baseUrl {
      return "https://6e8a-207-162-114-170.ngrok-free.app/PaySphereAPI"; // Web
  }
  // Méthode générique pour envoyer une requête POST
  static Future<Map<String, dynamic>?> post(String endpoint, Map<String, dynamic> body, {String? token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token"
     },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // Méthode générique pour envoyer une requête GET
  static Future<Map<String, dynamic>?> get(String endpoint, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token"
      },
    );

    return _handleResponse(response);
  }

  // Méthode générique pour envoyer une requête PUT
  static Future<Map<String, dynamic>?> put(String endpoint, Map<String, dynamic> body, {String? token}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // Méthode générique pour envoyer une requête DELETE
  static Future<Map<String, dynamic>?> delete(String endpoint, {String? token}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token"
      },
    );

    return _handleResponse(response);
  }

// Gestion des réponses HTTP
  static Map<String, dynamic>? _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Forcer le décodage en UTF-8
      String responseBody = utf8.decode(response.bodyBytes);
      return jsonDecode(responseBody);
    } else {
      print("Erreur API (${response.statusCode}): ${utf8.decode(response.bodyBytes)}");
      return null;
    }
  }
}
