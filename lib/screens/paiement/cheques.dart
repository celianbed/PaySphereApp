import 'package:flutter/material.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';

class ChequesPage extends StatelessWidget {
  const ChequesPage({super.key});

  Widget buildTile({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildListItem(String text, VoidCallback? onTap) {
    return Column(
      children: [
        ListTile(
          title: Text(text,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: "Chèques",
        onBack: () => Navigator.of(context).pop(),
        showNotifications: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              buildTile(
                icon: Icons.qr_code_scanner,
                label: "Scanner un chèque",
                color: Colors.blue,
              ),
              buildTile(
                icon: Icons.location_city,
                label: "Déposer un chèque\nen agence",
                color: Colors.blue,
              ),
              buildTile(
                icon: Icons.post_add,
                label: "Commander\nun chéquier",
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            "Historique",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                buildListItem("Consulter les chèques scannés", () {}),
                buildListItem("Consulter les chéquiers commandés", () {}),
              ],
            ),
          )
        ],
      ),
    );
  }
}