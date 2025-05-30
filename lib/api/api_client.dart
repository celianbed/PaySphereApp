import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static String get baseUrl {
    // Retourne l'URL de base pour les requêtes API
    return "https://api.celianbedminster.fr/PaySphereAPI"; // Web
  }

  // Méthode générique pour envoyer une requête POST
  static Future<Map<String, dynamic>?> post(
      String endpoint,
      Map<String, dynamic> body, {
        String? token,
      }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token", // Ajoute le token si fourni
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }


  // Méthode générique pour envoyer une requête GET
  static Future<Map<String, dynamic>?> get(
      String endpoint, {
        String? token,
      }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token", // Ajoute le token si fourni
      },
    );

    return _handleResponse(response);
  }

  // Méthode générique pour envoyer une requête PUT
  static Future<Map<String, dynamic>?> put(
      String endpoint,
      Map<String, dynamic> body, {
        String? token,
      }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token", // Ajoute le token si fourni
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // Méthode générique pour envoyer une requête DELETE
  static Future<Map<String, dynamic>?> delete(
      String endpoint, {
        String? token,
      }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token", // Ajoute le token si fourni
      },
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>?> patch(
      String endpoint,
      Map<String, dynamic> body, {
        String? token,
      }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token", // Ajoute le token si fourni
      },
      body: json.encode(body),
    );

    return _handleResponse(response);
  }

  // Gestion des réponses HTTP
  static Map<String, dynamic>? _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = utf8.decode(response.bodyBytes);

    // Vérifie si le statut HTTP indique un succès
    if (statusCode == 200 || statusCode == 201) {
      return jsonDecode(responseBody); // Retourne la réponse décodée
    } else {
      // Log l'erreur pour faciliter le débogage
      debugPrint("Erreur API ($statusCode): $responseBody");
      return {
        'error': true, // Indique qu'une erreur s'est produite
        'status': statusCode,
        'message': responseBody, // Retourne le message d'erreur
      };
    }
  }
}