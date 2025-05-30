import 'api_client.dart';

class VirementApi {

  static Future<bool> transfer(
      String token, int fromAccountId, String toAccountId, double amount) async {
    // Envoie une requête POST pour effectuer un virement
    // Les données incluent l'identifiant du compte source, l'IBAN du compte destinataire et le montant
    final data = await ApiClient.post(
        '/virement',
        {
          "from_account": fromAccountId,
          "to_account_iban": toAccountId,
          "montant": amount
        },
        token: token
    );

    // Retourne true si la réponse est valide, sinon false
    return data != null;
  }

  static Future<bool> verifierBeneficiaire(String iban, String token) async {
    // Envoie une requête POST pour vérifier si un IBAN est valide en tant que bénéficiaire
    final response = await ApiClient.post(
      '/virements/verifie-beneficiaire',
      {
        'to_account_iban': iban,
      },
      token: token,
    );

    // Vérifie si la réponse contient une clé "valid" et si elle est true
    return response != null && response['valid'] == true;
  }

}