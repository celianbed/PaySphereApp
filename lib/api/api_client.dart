import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../services/storage.dart';

class ApiClient {
  static String get _apiKey => dotenv.env['API_KEY'] ?? '';

  static String get baseUrl {
    return "https://paysphereapi.onrender.com/PaySphereAPI";
  }

  static bool _isRefreshing = false;
  static Function(String message)? onSessionExpired;

  static Map<String, String> _buildHeaders({String? token}) {
    return {
      "Content-Type": "application/json",
      "X-API-Key": _apiKey,
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<String?> _tryRefreshToken() async {
    if (_isRefreshing) return null;
    _isRefreshing = true;

    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) return null;

      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: _buildHeaders(token: refreshToken),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        final newAccessToken = body['access_token'] as String;
        await StorageService.setAccessToken(newAccessToken);
        return newAccessToken;
      }
      return null;
    } catch (e) {
      debugPrint("Erreur refresh token: $e");
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  static Future<void> _handleSessionExpired() async {
    await StorageService.deleteTokens();
    await StorageService.deleteClient();
    onSessionExpired?.call("Votre session a expiré. Veuillez vous reconnecter.");
  }

  static Future<http.Response> _requestWithRetry(
    Future<http.Response> Function(Map<String, String> headers) makeRequest, {
    String? token,
  }) async {
    var headers = _buildHeaders(token: token);
    var response = await makeRequest(headers);

    if (response.statusCode == 401 && token != null) {
      final newToken = await _tryRefreshToken();
      if (newToken != null) {
        headers = _buildHeaders(token: newToken);
        response = await makeRequest(headers);
      } else {
        await _handleSessionExpired();
      }
    }

    return response;
  }

  static Future<Map<String, dynamic>?> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final response = await _requestWithRetry(
      (headers) => http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      ),
      token: token,
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>?> get(
    String endpoint, {
    String? token,
  }) async {
    final response = await _requestWithRetry(
      (headers) => http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ),
      token: token,
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>?> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final response = await _requestWithRetry(
      (headers) => http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      ),
      token: token,
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>?> delete(
    String endpoint, {
    String? token,
  }) async {
    final response = await _requestWithRetry(
      (headers) => http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ),
      token: token,
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>?> patch(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final response = await _requestWithRetry(
      (headers) => http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      ),
      token: token,
    );
    return _handleResponse(response);
  }

  static Future<http.Response> getRaw(
    String endpoint, {
    String? token,
  }) async {
    return await _requestWithRetry(
      (headers) => http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ),
      token: token,
    );
  }

  static Map<String, dynamic>? _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = utf8.decode(response.bodyBytes);

    if (statusCode == 200 || statusCode == 201) {
      return jsonDecode(responseBody);
    } else {
      try {
        final errorData = jsonDecode(responseBody);
        debugPrint("Erreur API ($statusCode): $errorData");
        return {
          'error': true,
          'status': statusCode,
          'message': errorData['error'] ?? errorData['erreur'] ?? responseBody,
        };
      } catch (e) {
        debugPrint("Erreur API ($statusCode): $responseBody");
        return {
          'error': true,
          'status': statusCode,
          'message': "Une erreur est survenue. Veuillez réessayer.",
        };
      }
    }
  }

}
