import 'api_client.dart';

class PretApi {
  static Future<Map<String, dynamic>?> simuler(
      String token, double montant, int dureeMois) async {
    final data = await ApiClient.post(
      '/prets/simulation',
      {"montant": montant, "duree_mois": dureeMois},
      token: token,
    );
    if (data == null) return null;
    if (data.containsKey('simulation')) {
      return Map<String, dynamic>.from(data['simulation']);
    }
    if (data['error'] == true) {
      return {'error': true, 'message': data['message'] ?? 'Erreur inconnue'};
    }
    return data;
  }

  static Future<Map<String, dynamic>?> creerPret(
      String token, double montant, int dureeMois) async {
    final data = await ApiClient.post(
      '/prets',
      {"montant": montant, "duree_mois": dureeMois},
      token: token,
    );
    if (data != null && data.containsKey('pret')) {
      return Map<String, dynamic>.from(data['pret']);
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getPrets(String token) async {
    final data = await ApiClient.get('/prets', token: token);
    if (data != null && data.containsKey('prets')) {
      return List<Map<String, dynamic>>.from(data['prets']);
    }
    return [];
  }

  static Future<bool> annulerPret(String token, int pretId) async {
    final data = await ApiClient.post(
      '/prets/$pretId/annuler',
      {},
      token: token,
    );
    return data != null && data['error'] != true;
  }
}
