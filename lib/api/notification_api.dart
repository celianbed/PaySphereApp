import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/storage.dart';
import 'api_client.dart';

class NotificationApi {
  static List<Map<String, dynamic>> notifications = [];

  static Future<List<Map<String, dynamic>>> fetchNotifications(
    BuildContext context,
  ) async {
    final token = await StorageService.getAccessToken();

    try {
      final response = await ApiClient.getRaw('/notifications', token: token);

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        if (body is List) {
          final newNotifs = List<Map<String, dynamic>>.from(body);
          for (var notif in newNotifs) {
            if (!notifications.any((n) => n['id'] == notif['id'])) {
              notifications.add(notif);
            }
          }
          return newNotifs;
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur lors du chargement des notifications."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    return [];
  }

  static Future<void> marquerCommeVue(int id) async {
    final token = await StorageService.getAccessToken();
    await ApiClient.post("/notifications/$id/lu", {}, token: token);
  }
}
