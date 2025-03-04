import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: "access_token", value: accessToken);
    await _storage.write(key: "refresh_token", value: refreshToken);
  }

  static Future<void> saveIsLogin(String isLogin) async {
    await _storage.write(key: "isLogin", value: isLogin);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: "access_token");
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refresh_token");
  }

  static  Future<String?> getIsLogin() async {
    return await _storage.read(key: "isLogin");
  }

  static Future<void> deleteTokens() async {
    await _storage.delete(key: "access_token");
    await _storage.delete(key: "refresh_token");
  }

  static Future<void> setClientNumber(String clientNumber, bool isChecked) async {
    final prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      await prefs.setString('client_number', clientNumber);
    } else {
      await prefs.remove('client_number');
    }
  }
  static Future<void> setClientName(String nomClient, String prenomClient) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('client_nom', nomClient);
    await prefs.setString('client_prenom', prenomClient);

  }
  static Future<String?> getClientNom() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('client_nom');
  }

  static Future<String?> getClientPrenom() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('client_prenom');
  }

  static Future<String?> getKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<String?> getClientNum() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('client_id');
  }

}


