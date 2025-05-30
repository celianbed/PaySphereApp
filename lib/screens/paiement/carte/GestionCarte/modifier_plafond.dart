import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/providers/auth_providers.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';

import '../../../../models/carte_model.dart';
import '../../../../models/client_model.dart';

class ModifierPlafondPage extends StatefulWidget {
  final Carte carte;
  final Client? client;

  const ModifierPlafondPage({super.key, required this.carte, this.client});

  @override
  State<ModifierPlafondPage> createState() => _ModifierPlafondPageState();
}

class _ModifierPlafondPageState extends State<ModifierPlafondPage> {
  final List<int> plafonds = [0, 200, 500, 600, 1000, 1200, 1500];
  int? plafondSelectionne;

  @override
  void initState() {
    super.initState();
    plafondSelectionne = widget.carte.plafond.toInt();
  }

  void _choisirPlafond() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: plafonds.map((value) {
            return ListTile(
              title: Text('$value €',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              onTap: () => Navigator.pop(context, value),
            );
          }).toList(),
        );
      },
    );

    if (selected != null) {
      setState(() {
        plafondSelectionne = selected;
      });
    }
  }

  void _valider() {
    context.push('/verifier_code', extra: {
      'client': widget.client,
      'carte':widget.carte,
      'titre': 'Plafond modifié',
      'message': 'Votre plafond de paiement a bien été mis à jour.',
      'onSuccess': () async {

        AuthProvider auth = AuthProvider();

        final success = await auth.modifierPlafond(
          widget.carte.id,
          plafondSelectionne!.toDouble(),
        );

       widget.carte.plafond = plafondSelectionne!;

        if (success && context.mounted) {
          context.push('/confirmation', extra: {
            'titre': 'Plafond modifié',
            'message': 'Votre plafond a été enregistré avec succès.',
            "carte" : widget.carte,
            "client" : widget.client,
            "futurePush" : '/paiements/cartes/details-carte/plafonds'
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la mise à jour.')),
          );
        }
      },
    });

  }

  String getMaskedCardNumber(String num) {
    if (num.length < 4) return num;
    return '**** **** **** ${num.substring(num.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar:CustomAppBar(title: "Modifier plafond",
        onBack: () =>  context.pop(),
        showNotifications: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Carte visuelle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
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
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.carte.typeCarte.nom,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(getMaskedCardNumber(widget.carte.numeroCarte)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Plafond à modifier
            GestureDetector(
              onTap: _choisirPlafond,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue.shade700),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("PLAFOND DE PAIEMENT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                        SizedBox(height: 4),
                        Text(
                          "Sur 30 jours glissants",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    Text(
                      '$plafondSelectionne €',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Bouton Valider
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _valider,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Valider',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
