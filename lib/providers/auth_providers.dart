import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../api/auth_service.dart';
import '../api/carte_api.dart';
import '../services/storage.dart';

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  String? _clientID;
  bool _isAuthenticated = false;

  String? get accessToken => _accessToken;

  String? get clientID => _clientID;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String numClient, String password) async {
    // Appelle l'API pour effectuer la connexion et récupère les tokens d'accès
    final data = await AuthApi.login(numClient, password);

    if (data != null) {
      _accessToken = data['access_token']!;
      _clientID = numClient;
      _isAuthenticated = true;

      // Stocke les tokens d'accès et de rafraîchissement dans le stockage local
      await StorageService.setTokens(
        data['access_token']!,
        data['refresh_token']!,
      );
      notifyListeners();

      return true;
    }

    return false;
  }

  Future<void> checkAuthStatus() async {
    // Vérifie si un token d'accès est présent pour déterminer l'état d'authentification
    _accessToken = await StorageService.getAccessToken();
    _isAuthenticated = _accessToken != null;
    notifyListeners();
  }

  Future<bool> logout() async {
    // Récupère le token d'accès pour effectuer la déconnexion
    String? token = await StorageService.getAccessToken();

    // Appelle l'API pour déconnecter l'utilisateur
    bool isLogout = await AuthApi.logout(token);
    _isAuthenticated = false;
    _accessToken = null;

    // Supprime les tokens du stockage local
    await StorageService.deleteTokens();
    notifyListeners();

    return isLogout;
  }

  static Future<bool> verifierCode(String numClient, String password) async {
    // Envoie une requête POST pour vérifier un code utilisateur
    final data = await ApiClient.post('/verifier_code', {
      "num": numClient,
      "password": password,
    }).timeout(const Duration(seconds: 10));

    // Vérifie si la réponse indique un succès
    return data != null && data['success'] == true;
  }

  Future<bool> modifierPlafond(int carteId, double nouveauPlafond) async {
    // Récupère le token d'accès pour autoriser la modification
    String? token = await StorageService.getAccessToken();

    if (token == null) {
      return false;
    }

    // Appelle l'API pour modifier le plafond de paiement d'une carte
    bool isUpdated = await CarteApi.modifierPlafond(carteId, nouveauPlafond, token);

    if (isUpdated) {
      notifyListeners(); // Notifie les widgets écoutant ce provider
      return true;
    }

    return false;
  }
}