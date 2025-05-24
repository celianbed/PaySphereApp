import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';
import '../models/client_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showNotifications;
  final Client? client;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.client,
    this.showNotifications = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue.shade700,
      elevation: 2,
      toolbarHeight: 56, // ⬅️ HAUTEUR RÉDUITE
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 16, right: 16), // ⬅️ ajusté aussi
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (onBack != null)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: onBack,
                  ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (showNotifications)
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      // TODO : notifications
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.power_settings_new, color: Colors.white),
                  onPressed: () async {
                    bool confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Déconnexion"),
                          content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Oui", style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      bool isNotLogged = await AuthProvider().logout();
                      if (isNotLogged && context.mounted) {
                        context.go('/demarrage', extra: client);
                      }
                    }
                  },
                  tooltip: 'Déconnexion',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70); // ✅ mis à jour ici aussi
}
