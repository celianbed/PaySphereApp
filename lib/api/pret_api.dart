import 'api_client.dart';

class PretApi {
  static Map<String, dynamic>? simuler(double montant, int dureeMois) {
    if (montant < 500 || montant > 75000) return null;
    if (dureeMois <= 0) return null;

    double tauxAnnuel;
    if (dureeMois <= 12) {
      tauxAnnuel = 3.5;
    } else if (dureeMois <= 36) {
      tauxAnnuel = 4.2;
    } else {
      tauxAnnuel = 4.9;
    }

    final tauxMensuel = tauxAnnuel / 100 / 12;
    final puissance = _pow(1 + tauxMensuel, dureeMois);
    final mensualite = montant * tauxMensuel * puissance / (puissance - 1);
    final coutTotal = mensualite * dureeMois;
    final coutInterets = coutTotal - montant;

    return {
      'montant': montant,
      'duree_mois': dureeMois,
      'taux_interet': tauxAnnuel,
      'mensualite': mensualite,
      'cout_total': coutTotal,
      'cout_interets': coutInterets,
    };
  }

  static double _pow(double base, int exp) {
    double result = 1.0;
    for (int i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
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
