import 'package:flutter/material.dart';
import '../../models/client_model.dart';
import '../autres/navigation_wrapper.dart';
import '../autres/custom_app_bar.dart';

class ContactPage extends StatelessWidget {
  final Client? client;

  const ContactPage({super.key, required this.client});

  Widget _buildCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: child,
    );
  }

  Widget _buildLine(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 28, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 2,
      client: client,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          title: 'Contact',
          showNotifications: true,
          client: client,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (client != null)
                  Text(
                    "Mon conseiller",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                const SizedBox(height: 10),
                _buildLine(Icons.phone, 'Appeler', '', () {}),
                _buildLine(Icons.mail_outline, 'Échanger par message', 'Obtenez une réponse sous 72h ouvrées.', () {}),
                _buildLine(Icons.calendar_today, 'Prendre un rendez-vous', 'Consultez ou réservez un rendez-vous.', () {}),
              ],
            )),
            const SizedBox(height: 10),
            const Text("Assistance immédiate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text("La plupart des problèmes rencontrés peuvent être résolus en quelques minutes."),
            const SizedBox(height: 10),
            _buildCard(
              ListTile(
                title: const Text("Rechercher une solution"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 10),
            const Text("Autres agences", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text("Vous souhaitez réaliser une opération dans un autre lieu ?"),
            const SizedBox(height: 10),
            _buildCard(
              Column(
                children: [
                  ListTile(
                    title: const Text("Rechercher une agence ou un distributeur ?"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 0),
                  ListTile(
                    title: const Text("Trouver un distributeur à l'étranger ?"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
