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
              ),
              _optionTile(
                icon: Icons.wallet_giftcard,
                title: "Créer une cagnotte gratuitement",
                subtitle: "Lyf Pay",
                color: Colors.pink,
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
  }) {
    return Container(
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
    );
  }
}
