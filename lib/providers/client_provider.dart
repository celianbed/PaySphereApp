import 'package:flutter/material.dart';

import '../api/client_api.dart';
import '../models/client_model.dart';

class ClientProvider extends ChangeNotifier {
  Client? _client;

  // Getter pour récupérer le client actuel
  Client? get client => _client;

  // Définit un nouveau client et notifie les widgets écoutant ce provider
  void setClient(Client client) {
    _client = client;
    notifyListeners(); // Notifie les widgets pour qu'ils se mettent à jour
  }

  Future<void> loadClient(int? clientId, String token) async {
    // Appelle l'API pour récupérer les informations du client
    final response = await ClientApi.getClientInfo(clientId, token, null);

    if (response != null) {
      // Si la réponse est valide, crée un objet Client à partir des données JSON
      _client = Client.fromJson(response);
      notifyListeners(); // Notifie les widgets écoutant ce provider
    }
  }
}