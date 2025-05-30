import 'package:flutter/cupertino.dart';

import 'api_client.dart';

class ClientApi {
  static Future<Map<String, dynamic>?> getClientInfo(int? clientId, String token, BuildContext? context, {String? fields}) async {
    final Map<String, dynamic>? response;

    // Vérifie si des champs spécifiques sont demandés et construit l'URL en conséquence
    if (fields != null && fields.isNotEmpty) {
      response = await ApiClient.get('/clients/numero/$clientId?fields=$fields', token: token);
    } else {
      response = await ApiClient.get('/clients/numero/$clientId', token: token);
    }

    // Retourne la réponse si elle est valide, sinon retourne null
    if (response != null) {
      return response;
    }
    return null;
  }

  static Future<bool> miseAjourClient(
      int clientId,
      Map<String, dynamic> updateData,
      String token,
      BuildContext? context
      ) async {
    // Envoie une requête PATCH pour mettre à jour les informations du client
    final response = await ApiClient.patch(
      '/clients/$clientId',
      updateData,
      token: token,
    );

    // Vérifie si la réponse contient un identifiant client pour confirmer la mise à jour
    return response != null && response.containsKey('client_id');
  }

  static Future<bool> changerMotDePasse({
    required int? userId,
    required String ancienPassword,
    required String nouveauPassword,
    required String token,
  }) async {
    // Envoie une requête PATCH pour changer le mot de passe de l'utilisateur
    final data = await ApiClient.patch(
      '/users/$userId/change-password',
      {
        "ancien_password": ancienPassword,
        "nouveau_password": nouveauPassword,
      },
      token: token,
    );

    // Vérifie si le message de succès est présent dans la réponse
    return data != null && data['message'] == "Mot de passe mis à jour avec succès";
  }

  static Future<Map<String, dynamic>?> supprimerBeneficiaire(int id, String token) async {
    // Envoie une requête DELETE pour supprimer un bénéficiaire spécifique
    final data = await ApiClient.delete(
      '/clients/beneficiaires/$id',
      token: token,
    );

    // Retourne les données de la réponse, même en cas d'erreur
    return data;
  }
}