import 'package:flutter/material.dart';

import '../api/clientApp_api.dart';
import '../models/client_model.dart';

class ClientProvider extends ChangeNotifier {
  Client? _client;

  Client? get client => _client;

  Future<void> loadClient(int? clientId, String token) async {
    final response = await ClientAppApi.getClientInfo(clientId, token);

    if (response != null) {
      _client = Client.fromJson(response);
      notifyListeners();
    }
  }
}
