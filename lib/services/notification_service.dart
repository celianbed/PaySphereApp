import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/api/notification_api.dart';
import 'package:pay_sphere_app/models/client_model.dart';
import 'package:pay_sphere_app/services/storage.dart';

class NotificationService {
  static late final FlutterLocalNotificationsPlugin _plugin;

  static Timer? _timer;
  static Client? _client;

  /// Liste statique accessible depuis toute l'app
  static List<Map<String, dynamic>> notifications = [];

  static Future<void> initialize(
      BuildContext context,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      ) async {
    _plugin = flutterLocalNotificationsPlugin;

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    _client = await StorageService.getClient();

    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _checkNewNotifications(context),
    );
  }

  static Future<void> _checkNewNotifications(BuildContext context) async {
    if (_client == null) return;

    final notifs = await NotificationApi.fetchNotifications(context);

    // Supprime les doublons
    final newNotifs = notifs.where((n) => !notifications.any((existing) => existing["id"] == n["id"])).toList();

    if (newNotifs.isNotEmpty) {
      notifications.addAll(newNotifs);

      // Notification locale
      final notif = newNotifs.first;
      unreadCount++;
      await _showNotification("🔔 Nouvelle notification", notif["message"]);
    }
  }

  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'notif_channel',
      'Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _plugin.show(0, title, body, details);
  }

  static void stop() {
    _timer?.cancel();
  }

  static void showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Session expirée"),
        content: const Text("Votre session a expiré. Veuillez vous reconnecter."),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await StorageService.deleteTokens();
              if (context.mounted) {
                context.go('/login', extra: _client);
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  static int unreadCount = 0;

  static void resetUnreadCount() {
    unreadCount = 0;
  }
}
