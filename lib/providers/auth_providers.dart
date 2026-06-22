import 'package:flutter/material.dart';

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
    final data = await AuthApi.login(numClient, password);

    if (data != null) {
      _accessToken = data['access_token']!;
      _clientID = numClient;
      _isAuthenticated = true;

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
    _accessToken = await StorageService.getAccessToken();
    _isAuthenticated = _accessToken != null;
    notifyListeners();
  }

  Future<bool> logout() async {
    String? token = await StorageService.getAccessToken();

    bool isLogout = await AuthApi.logout(token);
    _isAuthenticated = false;
    _accessToken = null;

    await StorageService.deleteTokens();
    notifyListeners();

    return isLogout;
  }

  static Future<bool> verifierCode(String numClient, String password) async {
    final token = await StorageService.getAccessToken();
    if (token == null) return false;

    return await AuthApi.verifierCode(numClient, password, token);
  }

  Future<bool> modifierPlafond(int carteId, double nouveauPlafond) async {
    String? token = await StorageService.getAccessToken();

    if (token == null) {
      return false;
    }

    bool isUpdated =
        await CarteApi.modifierPlafond(carteId, nouveauPlafond, token);

    if (isUpdated) {
      notifyListeners();
      return true;
    }

    return false;
  }
}
