import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/models/carte_model.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import 'package:pay_sphere_app/services/storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../api/carte_api.dart';
import '../../../../models/client_model.dart';

class OppositionPage extends StatefulWidget {
  final Carte carte;
  final Client client;

  const OppositionPage({super.key, required this.carte, required this.client});

  @override
  State<OppositionPage> createState() => _OppositionPageState();

  Future<void> callPhoneNumber(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Impossible de lancer l\'appel pour $phoneNumber';
    }
  }
}

class _OppositionPageState extends State<OppositionPage> {


  void _valider() {
    context.push('/verifier_code', extra: {
      'client': widget.client,
      'carte':widget.carte,
      'titre': 'Opposition de votre carte',
      'message': 'Carte bien oposé',
      'onSuccess': () async {

        final token = await StorageService.getAccessToken();

        bool success = await CarteApi.opposerCarte(
          widget.carte.id,
          token!,
        );
        if (success && context.mounted) {
          widget.carte.active = false;
          context.push('/confirmation', extra: {
            'titre': 'Opposition',
            'message': 'Votre plafond a été enregistré avec succès.',
            "carte" : widget.carte,
            "client" : widget.client,
            "futurePush" :'/paiements/cartes'
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la mise à jour.')),
          );
        }
      },
    });
  }
  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: "Opposition",
      showNotifications: false,
      onBack: () => context.pop()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "FAIRE OPPOSITION",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withValues(alpha: .1), blurRadius: 6),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Veuillez sélectionner le motif d’opposition",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  _buildRadio("Perte"),
                  _buildRadio("Vol"),
                  _buildRadio("Utilisation frauduleuse"),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                          _valider();
                      },
                      child: const Text(
                        "Valider l’opposition",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "OPPOSER LA CARTE PAR TÉLÉPHONE",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildPhoneSection("France", "3477"),
            const SizedBox(height: 20),
            _buildPhoneSection("Étranger", "(+33) 1 40 14 44 00"),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: label,
      groupValue: selectedReason,
      onChanged: (value) {
        setState(() {
          selectedReason = value;
        });
      },
    );
  }

  Widget _buildPhoneSection(String location, String number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                "Service gratuit\n+ prix appel",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () async {
              final call = Uri.parse('tel:$number');
              if (await canLaunchUrl(call)) {
                launchUrl(call);
              } else {
                throw 'Could not launch $call';
              }
            },
            child: const Text(
              "Appeler l’assistance",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
