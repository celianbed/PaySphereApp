import 'api_client.dart';

class AccountApi {
  // Récupérer la liste des comptes de l'utilisateur
  static Future<List<dynamic>?> getAccounts(String token) async {
    final data = await ApiClient.get('/comptes', token: token);
    return data?['accounts']; // Liste des comptes
  }

  // Récupérer le détail d'un compte spécifique
  static Future<Map<String, dynamic>?> getAccountDetails(String token,
      int accountId) async {
    final data = await ApiClient.get('/comptes/$accountId', token: token);
    return data;
  }

}