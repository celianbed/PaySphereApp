import 'api_client.dart';

class AuthApi {
  static Future<Map<String, String>?> login(
      String numClient,
      String password,
      ) async {
    // Envoie une requête POST pour authentifier l'utilisateur
    // et récupère les tokens d'accès et de rafraîchissement
    final data = await ApiClient.post('/login', {
      "num": numClient,
      "password": password,
    }).timeout(const Duration(seconds: 10));

    // Vérifie si la réponse contient les tokens nécessaires
    if (data != null &&
        data.containsKey('access_token') &&
        data.containsKey('refresh_token')) {
      return {
        "access_token": data['access_token'].toString(),
        "refresh_token": data['refresh_token'].toString(),
      };
    }
    return null; // En cas d'erreur ou de réponse invalide
  }

  static Future<bool> register(
      String email,
      String password,
      String fullName,
      ) async {
    // Envoie une requête POST pour enregistrer un nouvel utilisateur
    final data = await ApiClient.post('/register', {
      "email": email,
      "password": password,
      "full_name": fullName,
    });

    // Retourne true si l'enregistrement a réussi
    return data != null;
  }

  static Future<bool> logout(String? token) async {
    // Envoie une requête POST pour déconnecter l'utilisateur
    final data = await ApiClient.post('/logout', {}, token: token);

    // Retourne true si la déconnexion a réussi
    return data != null;
  }

  static Future<bool> verifierCode(String numClient, String password) async {
    // Envoie une requête POST pour vérifier un code client et un mot de passe
    final data = await ApiClient.post('/verifier_code', {
      "num": numClient,
      "password": password,
    }).timeout(const Duration(seconds: 10));

    // Vérifie si la réponse contient une clé "success" et si elle est true
    if (data != null && data.containsKey('success')) {
      return data['success'] == true;
    }

    return false; // Retourne false en cas d'échec
  }
}