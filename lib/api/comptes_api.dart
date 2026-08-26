import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/compte_model.dart';
import 'api_client.dart';

class AccountApi {
  /// Récupère les comptes du client connecté.
  ///
  /// `GET /comptes` répond par un tableau JSON, pas par un objet. La version
  /// précédente passait par `ApiClient.get`, dont le type de retour est
  /// `Map<String, dynamic>?` : décoder un tableau y provoquait une erreur de
  /// type, et la lecture d'une clé `accounts` inexistante n'aurait de toute
  /// façon rien renvoyé. La réponse brute est donc décodée ici.
  static Future<List<Compte>> getAccounts(
      String token, BuildContext? context) async {
    final response = await ApiClient.getRaw('/comptes', token: token);

    if (response.statusCode != 200) {
      debugPrint("Comptes indisponibles (${response.statusCode}).");
      return [];
    }

    try {
      final corps = jsonDecode(utf8.decode(response.bodyBytes));
      if (corps is! List) return [];
      return corps
          .whereType<Map<String, dynamic>>()
          .map(Compte.fromJson)
          .toList();
    } catch (e) {
      debugPrint("Comptes illisibles : $e");
      return [];
    }
  }

  /// Récupère le détail d'un compte du client connecté.
  ///
  /// Retourne `null` si le compte n'existe pas ou n'appartient pas à
  /// l'appelant — l'API ne distingue pas les deux cas, afin de ne pas
  /// permettre d'énumérer les identifiants de comptes.
  static Future<Map<String, dynamic>?> getAccountDetails(
      String token, int accountId, BuildContext? context) async {
    final data = await ApiClient.get('/comptes/$accountId', token: token);
    return ApiClient.estErreur(data) ? null : data;
  }
}
