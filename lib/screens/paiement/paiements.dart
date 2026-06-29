import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/models/client_model.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import '../autres/navigation_wrapper.dart';

class PaiementsPage extends StatelessWidget {
  final Client? client;

  const PaiementsPage({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 1,
      client: client,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(title: 'Paiements', client: client,showNotifications: true,),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildPaymentTile(
                    context,
                    icon: Icons.credit_card,
                    label: "Cartes",
                    onTap: () => context.push('/paiements/cartes', extra: {
                      "client" :client
                    }),
                  ),
                  _buildPaymentTile(
                    context,
                    icon: Icons.sync_alt,
                    label: "Virements",
                    onTap: () => context.push('/virements', extra: {
                      "client" : client
                    }),
                  ),
                  _buildPaymentTile(
                    context,
                    icon: Icons.description,
                    label: "RIB",
                    onTap: () => context.push('/rib', extra: client),
                  ),
                  _buildPaymentTile(
                    context,
                    icon: Icons.edit_document,
                    label: "Chèques",
                    onTap: () => context.push('/cheques', extra: client),
                  ),
                  _buildPaymentTile(
                    context,
                    icon: Icons.account_balance,
                    label: "Prêts",
                    onTap: () => context.push('/prets', extra: {
                      "client": client,
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Plus d'options",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _optionTile(
                icon: Icons.phone_iphone,
                title: "Payer en magasin et en ligne",
                subtitle: "Apple Pay",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ApplePayPage(client: client),
                  ));
                },
              ),
              _optionTile(
                icon: Icons.euro,
                title: "Envoyer de l'argent instantanément",
                subtitle: "Wero",
                color: Colors.teal,
              ),
              _optionTile(
                icon: Icons.payment,
                title: "Payer en ligne",
                subtitle: "PayPal",
                color: Colors.indigo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTile(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black12.withValues(alpha: 0.05), blurRadius: 4)],
        ),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue.shade700),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color color = Colors.black87,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    ));
  }
}

class ApplePayPage extends StatelessWidget {
  final Client? client;
  const ApplePayPage({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    final cardName = client != null
        ? "${client!.prenom} ${client!.nom}".toUpperCase()
        : "JEAN DUPONT";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Apple Pay"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("PaySphere", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Icon(Icons.apple, color: Colors.white, size: 30),
                    ],
                  ),
                  const Text(
                    "**** **** **** 4921",
                    style: TextStyle(color: Colors.white70, fontSize: 22, letterSpacing: 3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("TITULAIRE", style: TextStyle(color: Colors.white38, fontSize: 10)),
                          Text(cardName, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("EXP", style: TextStyle(color: Colors.white38, fontSize: 10)),
                          Text("12/28", style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: const Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 12),
                  Text("Carte ajoutée à Apple Pay", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    "Vous pouvez utiliser Apple Pay pour payer en magasin, en ligne et dans les applications.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _infoRow("Statut", "Active"),
                  const Divider(),
                  _infoRow("Appareil", "iPhone"),
                  const Divider(),
                  _infoRow("Réseau", "Visa"),
                  const Divider(),
                  _infoRow("Numéro de compte", "...4921"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
