import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../services/storage.dart';

class ApiClient {
  static String get _apiKey => dotenv.env['API_KEY'] ?? '';

  /// URL de l'API, surchargeable par la variable d'environnement `API_BASE_URL`
  /// afin de pouvoir viser une instance locale (`docker compose up`) sans
  /// modifier le code.
  static String get baseUrl {
    return dotenv.env['API_BASE_URL']?.isNotEmpty == true
        ? dotenv.env['API_BASE_URL']!
        : "https://paysphereapi.onrender.com/PaySphereAPI";
  }

  /// Délai accordé à une instance déjà démarrée.
  static const Duration delaiStandard = Duration(seconds: 20);

  /// Délai accordé au réveil d'une instance mise en veille par l'hébergeur.
  ///
  /// L'offre gratuite de Render arrête l'instance après quinze minutes sans
  /// trafic ; le premier appel qui la réveille peut demander plus d'une
  /// minute. Un délai de dix secondes garantissait l'échec de la première
  /// connexion après toute période d'inactivité.
  static const Duration delaiReveil = Duration(seconds: 90);

  /// Faux tant qu'aucune réponse n'a été obtenue depuis le lancement.
  static bool _serveurEveille = false;

  static bool get serveurEveille => _serveurEveille;

  static bool _isRefreshing = false;
  static Function(String message)? onSessionExpired;

  /// Appelé lorsqu'une requête dure assez longtemps pour qu'il faille en
  /// informer l'utilisateur plutôt que de le laisser devant un écran figé.
  static void Function()? onReveilServeur;

  /// Délai à appliquer selon que l'instance est déjà réveillée ou non.
  static Duration get _delaiCourant =>
      _serveurEveille ? delaiStandard : delaiReveil;

  /// Sollicite la sonde de santé pour réveiller l'instance avant une action
  /// utilisateur, sans consommer d'identifiants.
  ///
  /// Retourne `true` dès que l'API répond. La sonde est volontairement exemptée
  /// de clé API et d'authentification côté serveur.
  static Future<bool> reveillerServeur() async {
    if (_serveurEveille) return true;

    final minuteur = Timer(const Duration(seconds: 3), () {
      if (!_serveurEveille) onReveilServeur?.call();
    });

    try {
      final reponse = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(delaiReveil);
      _serveurEveille = reponse.statusCode == 200;
      return _serveurEveille;
    } catch (e) {
      debugPrint("Réveil du serveur impossible : $e");
      return false;
    } finally {
      minuteur.cancel();
    }
  }

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

      final response = await http
          .post(
            Uri.parse('$baseUrl/refresh'),
            headers: _buildHeaders(token: refreshToken),
          )
          .timeout(_delaiCourant);

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

    // Le délai est appliqué ici, une seule fois, plutôt que dans chaque
    // appelant : c'est ce qui laissait subsister un délai de dix secondes sur
    // l'écran de connexion.
    final minuteur = Timer(const Duration(seconds: 3), () {
      if (!_serveurEveille) onReveilServeur?.call();
    });

    http.Response response;
    try {
      response = await makeRequest(headers).timeout(_delaiCourant);
      _serveurEveille = true;
    } finally {
      minuteur.cancel();
    }

    if (response.statusCode == 401 && token != null) {
      final newToken = await _tryRefreshToken();
      if (newToken != null) {
        headers = _buildHeaders(token: newToken);
        response = await makeRequest(headers).timeout(delaiStandard);
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
