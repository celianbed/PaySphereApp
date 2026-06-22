import 'package:flutter/foundation.dart';
import 'api_client.dart';

class AuthApi {
  static Future<Map<String, String>?> login(
    String numClient,
    String password,
  ) async {
    final data = await ApiClient.post('/login', {
      "num": numClient,
      "password": password,
    }).timeout(const Duration(seconds: 10));

    if (data == null) {
      debugPrint("AuthApi.login: API returned null");
      return null;
    }

    debugPrint("AuthApi.login response: $data");

    if (data.containsKey('error') && data['error'] == true) {
      debugPrint("AuthApi.login error: ${data['message']}");
      return null;
    }

    if (data.containsKey('access_token') &&
        data.containsKey('refresh_token')) {
      return {
        "access_token": data['access_token'].toString(),
        "refresh_token": data['refresh_token'].toString(),
      };
    }

    debugPrint("AuthApi.login: Missing tokens in response");
    return null;
  }

  static Future<bool> register(
    String email,
    String password,
    String fullName,
  ) async {
    final data = await ApiClient.post('/register', {
      "email": email,
      "password": password,
      "full_name": fullName,
    });

    return data != null && data['error'] != true;
  }

  static Future<bool> logout(String? token) async {
    final data = await ApiClient.post('/logout', {}, token: token);
    return data != null && data['error'] != true;
  }

  static Future<bool> verifierCode(String numClient, String password, String token) async {
    final data = await ApiClient.post('/verifier_code', {
      "num": numClient,
      "password": password,
    }, token: token).timeout(const Duration(seconds: 10));

    if (data != null && data.containsKey('success')) {
      return data['success'] == true;
    }

    return false;
  }
}
