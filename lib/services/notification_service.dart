import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/api/notification_api.dart';
import 'package:pay_sphere_app/models/client_model.dart';
import 'package:pay_sphere_app/services/storage.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin? _plugin;

  static Timer? _timer;
  static Client? _client;

  static List<Map<String, dynamic>> notifications = [];

  static GlobalKey<NavigatorState>? _navigatorKey;

  static Future<void> initialize(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    _navigatorKey = navigatorKey;

    if (_plugin == null) {
      _plugin = flutterLocalNotificationsPlugin;

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();
      const InitializationSettings settings =
          InitializationSettings(android: androidSettings, iOS: iosSettings);

      await _plugin!.initialize(settings);

      final androidImpl = _plugin!.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
    }

    notifications.clear();
    NotificationApi.notifications.clear();
    unreadCount = 0;

    _client = await StorageService.getClient();

    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkNewNotifications(),
    );
  }

  static Future<void> _checkNewNotifications() async {
    if (_client == null) return;
    final context = _navigatorKey?.currentContext;
    if (context == null) return;

    final token = await StorageService.getAccessToken();
    if (token == null) {
      stop();
      return;
    }

    final notifs = await NotificationApi.fetchNotifications(context);

    final newNotifs = notifs
        .where(
            (n) => !notifications.any((existing) => existing["id"] == n["id"]))
        .toList();

    if (newNotifs.isNotEmpty) {
      notifications.addAll(newNotifs);

      for (final notif in newNotifs) {
        unreadCount++;
        final type = notif["type_notification"] ?? "";
        final title = type == "virement_recu"
            ? "Virement reçu"
            : type == "virement_envoye"
                ? "Virement envoyé"
                : "PaySphere";
        await _showNotification(title, notif["message"]);
      }
    }
  }

  static Future<void> checkNow() async {
    await _checkNewNotifications();
  }

  static int _notifId = 0;

  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'notif_channel',
      'Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _plugin?.show(_notifId++, title, body, details);
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
  }

  static void clear() {
    stop();
    notifications.clear();
    NotificationApi.notifications.clear();
    unreadCount = 0;
    _notifId = 0;
    _client = null;
  }

  static void showSessionExpiredDialog(BuildContext context) {
    final client = _client;
    clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Session expirée"),
        content: const Text(
            "Votre session a expiré. Veuillez vous reconnecter."),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await StorageService.deleteTokens();
              if (context.mounted) {
                context.go('/login', extra: client);
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
