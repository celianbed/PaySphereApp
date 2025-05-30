import 'api_client.dart';

class CarteApi {
  static Future<bool> opposerCarte(int carteId, String token) async {
    // Envoie une requête POST pour opposer une carte spécifique
    final data = await ApiClient.post(
      '/cartes/$carteId/opposee',{},
      token: token,
    );
    // Vérifie si l'opération a réussi en analysant la réponse
    if (data != null && data['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> modifierPlafond(int carteId, double plafondPaiement, String token) async {
    // Envoie une requête PATCH pour modifier le plafond de paiement d'une carte
    final data = await ApiClient.patch(
      '/cartes/$carteId/plafond',
      {
        "plafond_paiement": plafondPaiement,
      },
      token: token,
    );

    // Vérifie si le message de succès est présent dans la réponse
    return data != null && data['message'] == 'Plafond mis à jour avec succès';
  }

  static Future<bool> setOptionTravel(int carteId, bool active, String token) async {
    // Envoie une requête PATCH pour activer ou désactiver l'option "Travel" d'une carte
    final data = await ApiClient.patch(
      '/cartes/$carteId/option-travel',
      {
        "active": active,
      },
      token: token,
    );
    // Vérifie si l'opération a réussi
    return data != null && data['success'] == true;
  }

  static Future<bool> setPaiementSansContact(int carteId, bool active, String token) async {
    // Envoie une requête PATCH pour activer ou désactiver le paiement sans contact
    final data = await ApiClient.patch(
      '/cartes/$carteId/paiement-sans-contact',
      {
        "active": active,
      },
      token: token,
    );
    // Vérifie si l'opération a réussi
    return data != null && data['success'] == true;
  }

  static Future<bool> setPaiementEnLigne(int carteId, bool active, String token) async {
    // Envoie une requête PATCH pour activer ou désactiver le paiement en ligne
    final data = await ApiClient.patch(
      '/cartes/$carteId/paiement-en-ligne',
      {
        "active": active,
      },
      token: token,
    );
    // Vérifie si l'opération a réussi
    return data != null && data['success'] == true;
  }
}