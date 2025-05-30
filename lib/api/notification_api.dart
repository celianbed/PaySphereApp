import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/notification_service.dart';
import '../services/storage.dart';
import 'api_client.dart';

class NotificationApi {
  static String baseUrl = ApiClient.baseUrl;
  static List<Map<String, dynamic>> notifications = [];

  static Future<List<Map<String, dynamic>>> fetchNotifications(
      BuildContext context,
      ) async {
    final token = await StorageService.getAccessToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is List) {
          // Ajoute uniquement les nouvelles notifications qui ne sont pas déjà dans la liste
          final newNotifs = List<Map<String, dynamic>>.from(body);
          for (var notif in newNotifs) {
            if (!notifications.any((n) => n['id'] == notif['id'])) {
              notifications.add(notif);
            }
          }
          return newNotifs;
        }
      } else if (response.statusCode == 401) {
        // Affiche une boîte de dialogue si la session a expiré
        NotificationService.showSessionExpiredDialog(context);
      }
    } catch (e) {
      if (context.mounted) {
        // Affiche un message d'erreur dans une barre de notification en cas d'exception
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Une erreur est survenue lors du chargement des notifications.",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    return [];
  }
}