import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/models/client_model.dart';
import 'package:pay_sphere_app/screens/custom_app_bar.dart';
import '../navigation_wrapper.dart';

class PaiementsPage extends StatelessWidget {

  final Client? client;

  const PaiementsPage({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 1, // correspond à l’onglet Paiements
      client: client,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: const CustomAppBar(title: 'Paiments'),
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
                  GestureDetector(
                    onTap: () => context.push('/cartes', extra: client),
                    child: const _PaymentTile(label: "Cartes", icon: Icons.credit_card),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/virements', extra: client),
                    child: const _PaymentTile(label: "Virements", icon: Icons.sync_alt),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/rib', extra: client),
                    child: const _PaymentTile(label: "RIB", icon: Icons.description),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/cheques', extra: client),
                    child: const _PaymentTile(label: "Chèques", icon: Icons.edit_document),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Plus d'options",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _optionTile(
                context,
                logo: Icons.phone_iphone,
                title: "Payer en magasin et en ligne",
                subtitle: "Apple Pay",
              ),
              _optionTile(
                context,
                logo: Icons.wallet_giftcard,
                title: "Créer une cagnotte gratuitement",
                subtitle: "Lyf Pay",
                color: Colors.pink,
              ),
              _optionTile(
                context,
                logo: Icons.payment,
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

  Widget _optionTile(BuildContext context,
      {required IconData logo,
        required String title,
        required String subtitle,
        Color color = Colors.black}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(logo, size: 30, color: color),
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

class _PaymentTile extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PaymentTile({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.teal.shade600),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
