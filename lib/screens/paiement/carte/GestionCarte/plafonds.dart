import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/carte_model.dart';
import '../../../../models/client_model.dart';
import '../../../autres/custom_app_bar.dart';

class CartePlafondPage extends StatefulWidget {
  final Carte carte;
  final Client? client;

  const CartePlafondPage({
    super.key,
    required this.carte,
    this.client,
  });

  @override
  State<CartePlafondPage> createState() => _CartePlafondPageState();
}

class _CartePlafondPageState extends State<CartePlafondPage> {
  late Carte _carte;
  late Client? _client;

  @override
  void initState() {
    super.initState();
    _carte = widget.carte;
    _client = widget.client;
  }

  String maskCardNumber(String numero) {
    if (numero.length != 16) return numero;
    return '${numero.substring(0, 4)} **** **** ${numero.substring(12)}';
  }

  @override
  Widget build(BuildContext context) {
    double plafondTotal = _carte.plafond.toDouble();
    double montantUtilise = 300.0;
    double progress = (plafondTotal > 0) ? montantUtilise / plafondTotal : 0.0;
    progress = progress.clamp(0.0, 1.0); // Évite les dépassements

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Carte ${_carte.typeCarte.nom}',
        client: _client,
        showNotifications: false,
        onBack: () => context.go('/paiements/cartes/details-carte', extra: {
          'carte': _carte,
          'client': _client,
        }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations carte
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_carte.typeCarte.nom,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Numéro : ${maskCardNumber(_carte.numeroCarte)}',
                      style: const TextStyle(color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Plafond de paiement',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vous disposez d’un plafond de paiement sur 30 jours glissants.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Carte Plafond
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${plafondTotal.toStringAsFixed(2)} €',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blue.shade700,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Utilisé : ${montantUtilise.toStringAsFixed(2)} €',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await context.push(
                    '/paiements/cartes/details-carte/plafonds/modifier-plafond',
                    extra: {'carte': _carte, 'client': _client},
                  );

                  if (result != null &&
                      result is Map<String, dynamic> &&
                      result.containsKey('carte')) {
                    setState(() {
                      _carte = result['carte'];
                      _client = result['client'];
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                ),
                child: const Text(
                  'Modifier le plafond',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
