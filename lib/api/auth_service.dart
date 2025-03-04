import 'api_client.dart';

class AuthApi {
  // Connexion utilisateur
  static Future<Map<String, String>?> login(String numClient, String password) async {
    final data = await ApiClient.post('/login', {
      "num": numClient,
      "password": password
    });

    if (data != null && data.containsKey('access_token') && data.containsKey('refresh_token')) {
      return {
        "access_token": data['access_token'].toString(),
        "refresh_token": data['refresh_token'].toString(),
      };
    }
    return null;  // En cas d'erreur
  }


  // Inscription utilisateur (si nécessaire)
  static Future<bool> register(String email, String password, String fullName) async {
    final data = await ApiClient.post('/register', {
      "email": email,
      "password": password,
      "full_name": fullName
    });

    return data != null; // True si l'inscription réussit
  }

  // Déconnexion (optionnel si le token est géré en local)
  static Future<bool> logout() async {
    // En local, il suffit de supprimer le token stocké
    return true;
  }
}
