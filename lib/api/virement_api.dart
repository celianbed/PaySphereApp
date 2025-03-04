import 'api_client.dart';

class VirementApi {
// Effectuer un virement entre comptes
  static Future<bool> transfer(
      String token, int fromAccountId, int toAccountId, double amount) async {
    final data = await ApiClient.post(
        '/transfer',
        {
          "from_account": fromAccountId,
          "to_account": toAccountId,
          "amount": amount
        },
    );

    return data != null; // True si le virement a réussi
  }
}
