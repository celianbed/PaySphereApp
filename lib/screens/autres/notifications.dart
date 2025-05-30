import 'package:flutter/material.dart';
import 'package:pay_sphere_app/api/notification_api.dart';
import 'package:pay_sphere_app/services/notification_service.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await NotificationApi.fetchNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    final notifs = NotificationService.notifications;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        showNotifications: false,
        onBack: () => Navigator.pop(context),
      ),
      body: notifs == []
          ? const Center(child: CircularProgressIndicator())
          : notifs.isEmpty
          ? const Center(child: Text("Aucune notification"))
          : RefreshIndicator(
        onRefresh: _loadNotifications,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: notifs.length,
          itemBuilder: (_, index) {
            final notif = notifs[index];
            return ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(notif["message"]),
              subtitle: Text(notif["type_notification"] ?? ""),
              trailing: Text(
                notif["date_envoi"].toString().split("T").first,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}
