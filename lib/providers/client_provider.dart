import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../api/client_api.dart';
import '../models/client_model.dart';

class ClientProvider extends ChangeNotifier {
  Client? _client;

  /// Message de la dernière erreur de chargement, `null` si tout s'est bien
  /// passé. Permet à l'écran appelant d'expliquer l'échec plutôt que de
  /// poursuivre avec un client absent.
  String? _erreur;

  // Getter pour récupérer le client actuel
  Client? get client => _client;

  String? get erreur => _erreur;

  // Définit un nouveau client et notifie les widgets écoutant ce provider
  void setClient(Client client) {
    _client = client;
    notifyListeners(); // Notifie les widgets pour qu'ils se mettent à jour
  }

  /// Charge le client depuis l'API.
  ///
  /// Retourne `true` si le client a pu être chargé.
  ///
  /// La réponse est validée avant d'être désérialisée : en cas d'erreur HTTP,
  /// `ApiClient` renvoie un descripteur d'erreur, non nul, que l'ancienne
  /// version passait directement à `Client.fromJson`. Le champ `client_id`
  /// étant alors absent, `int.parse('null')` levait une `FormatException`
  /// remontant jusqu'à l'interface.
  Future<bool> loadClient(int? clientId, String token) async {
    _erreur = null;

    final response = await ClientApi.getClientInfo(clientId, token, null);

    if (ApiClient.estErreur(response)) {
      _erreur = response?['message']?.toString() ??
          "Impossible de joindre le serveur.";
      notifyListeners();
      return false;
    }

    try {
      _client = Client.fromJson(response!);
      notifyListeners();
      return true;
    } catch (e) {
      // Réponse bien formée au sens HTTP mais inexploitable : on le signale
      // au lieu de laisser l'exception traverser l'interface.
      debugPrint("Client illisible : $e");
      _erreur = "Réponse du serveur inexploitable.";
      notifyListeners();
      return false;
    }
  }
}
