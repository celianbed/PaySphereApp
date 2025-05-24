import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay_sphere_app/screens/custom_app_bar.dart';
import '../../../models/client_model.dart';
import '../../navigation_wrapper.dart';

class CartesPage extends StatelessWidget {
  final Client? client;

  const CartesPage({super.key, required this.client});

  String maskNumeroCarte(String numero) {
    if (numero.length < 4) return '****';
    return '**** **** **** ${numero.substring(numero.length - 4)}';
  }

  String formatDate(String dateStr) {
    try {
      final parsed = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US')
          .parse(dateStr, true)
          .toLocal();
      return DateFormat('MM/yy').format(parsed);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 1,
      client: client,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          title: "Cartes",
          client: client,
          onBack: () => Navigator.pop(context),
          showNotifications: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (client != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "M ${client!.nom.toUpperCase()} ${client!.prenom.toUpperCase()}",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ...client!.comptes.expand((compte) => compte.cartes).map((carte) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icone VISA (à personnaliser plus tard)
                      Container(
                        width: 50,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'VISA',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              carte.typeCarte.nom,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "N° ${maskNumeroCarte(carte.numeroCarte)}",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            Text(
                              "Expire à fin ${formatDate(carte.dateExpiration)}",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            Text(
                              "Compte de chèques N° **** ${carte.numeroCompte.toString().padLeft(4, '0').substring(carte.numeroCompte.toString().length - 4)}",
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // TODO: action à définir
                  },
                  child: const Text(
                    "Découvrir toutes nos cartes",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
