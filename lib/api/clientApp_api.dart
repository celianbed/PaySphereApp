import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';

class ClientAppApi {
  static Future<Map<String, dynamic>?> getClientInfo(int? clientId, String token, {String? fields}) async {
    final response;

    if (fields != null && fields.isNotEmpty) {
      response = await ApiClient.get('/clients/numero/$clientId?fields=$fields', token: token);
    } else {
      response = await ApiClient.get('/clients/numero/$clientId', token: token);
    }

    if (response != null && response is Map<String, dynamic>) {
      print(response);
      return response; // Retourne directement le JSON si c'est un Map
    }



    return null;
  }
}