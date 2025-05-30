import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import '../../models/client_model.dart';
import '../autres/navigation_wrapper.dart';

class VirementsPage extends StatelessWidget {
  final Client? client;

  const VirementsPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 1,
      client: client,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(title: "Virements",
            client: client,
            showNotifications: false,
            onBack: () => context.push("/paiements" , extra: {
              "client":client
            })

        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _menuItem(
              context,
              icon: Icons.compare_arrows,
              title: "Nouveau virement",
              subtitle: "Réalisez un nouveau virement.",
              onTap: () {
                context.push("/virements/nouveau-virement", extra: {
                  "client" :client
                });
              },
            ),
            _menuItem(
              context,
              icon: Icons.group,
              title: "Bénéficiaires",
              subtitle: "Gérez et ajoutez des bénéficiaires.",
              onTap: () {
                context.push("/virements/beneficiaires", extra: {
                  "client" :client
                });
              },
            ),
            _menuItem(
              context,
              icon: Icons.history,
              title: "Historique",
              subtitle: "Retrouvez vos virements réalisés et programmés.",
              onTap: () {
                context.push("/virements/historique",extra: {
                  "client": client
                });
              },
            ),
            const SizedBox(height: 32),
            const Text("Plus d’options", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Envoyer de l’argent sans saisir de RIB avec Wero",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Un numéro de mobile ou une adresse e-mail suffisent pour envoyer de l’argent à un contact.",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, size: 28, color: Colors.blue.shade700),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}