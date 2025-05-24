import 'package:flutter/material.dart';
import '../api/auth_service.dart';
import '../services/storage.dart';

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  String? _clientID;
  bool _isAuthenticated = false;

  String? get accessToken => _accessToken;
  String? get clientID => _clientID;
  bool get isAuthenticated => _isAuthenticated;

  // Connexion utilisateur
  Future<bool> login(String numClient, String password) async {
    final data = await AuthApi.login(numClient, password);

    if (data != null) {
      _accessToken = data['access_token']!;
      _clientID = numClient;
      _isAuthenticated = true;
      await StorageService.setTokens(data['access_token']!, data['refresh_token']!);
      notifyListeners();

      print (await StorageService.getAccessToken());

      return true;
    } else {
      print("Erreur de connexion");
    }

    return false;
  }
  // Vérifier si l'utilisateur est connecté au démarrage
  Future<void> checkAuthStatus() async {
    _accessToken = await StorageService.getAccessToken();
    _isAuthenticated = _accessToken != null;
    notifyListeners();
  }

  // Déconnexion utilisateur
  Future<bool> logout() async {

    String? token = await StorageService.getAccessToken();

    print(token);
    bool isLogout = await AuthApi.logout(token);
    _isAuthenticated = false;
    _accessToken = null;
    await StorageService.deleteTokens();
    notifyListeners();

    if (isLogout) {
      return true;
    }

    return false;
  }
}
