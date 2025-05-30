import 'package:flutter/cupertino.dart';

import 'api_client.dart';

class AccountApi {

  static Future<List<dynamic>?> getAccounts(String token, BuildContext? context) async {
    // Appelle l'API pour récupérer la liste des comptes associés à l'utilisateur
    // Retourne uniquement la clé 'accounts' de la réponse
    final data = await ApiClient.get('/comptes', token: token);
    return data?['accounts']; // Liste des comptes
  }

  static Future<Map<String, dynamic>?> getAccountDetails(String token, int accountId, BuildContext? context) async {
    // Appelle l'API pour récupérer les détails d'un compte spécifique
    // Utilise l'identifiant du compte pour construire l'URL
    final data = await ApiClient.get('/comptes/$accountId', token: token);
    return data; // Retourne les détails du compte sous forme de Map
  }
}