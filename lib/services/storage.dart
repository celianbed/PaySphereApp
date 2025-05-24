import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/client_model.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> setTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: "access_token", value: accessToken);
    await _storage.write(key: "refresh_token", value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: "access_token");
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refresh_token");
  }

  static Future<void> deleteTokens() async {
    await _storage.delete(key: "access_token");
    await _storage.delete(key: "refresh_token");
  }

  static Future<void> setIsInfoSaved(String isSaved) async {
     await _storage.write(key: "isSaved", value: isSaved);
  }

  static Future<String?> getIsInfoSaved() async {
    return await _storage.read(key: "isSaved");
  }

  static Future<void> setClient(Client? client) async {
    final String clientJson = json.encode(client?.toJson());
    // Convertir Client en JSON
    await _storage.write(key: "Client", value: clientJson);
  }

  static Future<Client?> getClient() async {
    final String? clientJson = await _storage.read(key: "Client");

    if (clientJson == null) return null; // Si aucune donnée, on retourne null

    debugPrint(clientJson,wrapWidth: 1024);

    try {
      final Map<String, dynamic> clientMap = json.decode(clientJson);
      return Client.fromJson(clientMap);
    } catch (e) {
      print("Erreur lors du parsing de Client : $e");
      return null;
    }
  }

  static Future<void> setClientNum(String clientNumber) async {
    final prefs = await SharedPreferences.getInstance();
      await prefs.setString('client_number', clientNumber);
  }

  static Future<String?> getClientNum() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('client_number');
  }

  static Future<void> setClientNom(String nomClient, String prenomClient) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('client_nom', nomClient);
    await prefs.setString('client_prenom', prenomClient);
  }

  static Future<String?> getClientNom() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('client_nom');
  }
}
