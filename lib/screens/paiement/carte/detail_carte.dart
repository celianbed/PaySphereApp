import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/carte_model.dart';
import '../../../models/client_model.dart';
import '../../autres/custom_app_bar.dart';

class CarteDetailPage extends StatelessWidget {
  final Carte carte;
  final Client? client;

  const CarteDetailPage({super.key, required this.carte, this.client});

  String maskMiddleCardNumber(String numero) {
    if (numero.length != 16) return numero;
    return '${numero.substring(0, 4)} **** **** ${numero.substring(12)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Carte ${carte.typeCarte.nom}',
        showNotifications: false,
        onBack: () => context.go('/paiements/cartes',extra: {
          "client":client
        }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardInfo(context),
            const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 24),
            const Text(
              'Gestion de la carte',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 16),
            _buildOption(context, Icons.cancel, 'Faire opposition',
                'Opposez votre carte en cas de vol ou de perte.',"/paiements/cartes/details-carte/opposition",carte,client!),
            _buildOption(context, Icons.pie_chart, 'Consulter les plafonds.',
                'Consultez et modifiez vos limites de paiements.',"/paiements/cartes/details-carte/plafonds",carte,client!),
            _buildOption(context, Icons.wifi, 'Paiement sans contact.',
                'Activez ou désactivez les paiements en magasin.',"/paiements/cartes/details-carte/modifier-paimement-sans-contact",carte,client!),
            _buildOption(context, Icons.lock, 'Paiement en ligne.',
                'Gérez vos paiements sur internet.',"/paiements/cartes/details-carte/modifier-paimement-en-ligne",carte,client!),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showBottomDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Détails de la carte',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700),
              ),
              const SizedBox(height: 24),
              _buildDetailLine('Titulaire', '${client?.prenom} ${client?.nom}'),
              const SizedBox(height: 14),
              _buildDetailLine('Compte associé', 'N° ${carte.numeroCompte}'),
              const SizedBox(height: 14),
              _buildDetailLine(
                  'Numéro de carte', maskMiddleCardNumber(carte.numeroCarte)),
              const SizedBox(height: 14),
              _buildDetailLine('Date d\'expiration',
                  '${carte.dateExpiration.substring(5, 7)}/${carte.dateExpiration.substring(2, 4)}'),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Fermer"),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailLine(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
      ],
    );
  }

  Widget _buildCardInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            carte.typeCarte.nom,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
              'Numéro : **** **** **** ${carte.numeroCarte.substring(carte.numeroCarte.length - 4)}'),
          const SizedBox(height: 6),
          Text(
              'Expiration : ${carte.dateExpiration.substring(5, 7)}/${carte.dateExpiration.substring(2, 4)}'),
          const SizedBox(height: 6),
          const Text('Code sécurité : ***'),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => _showBottomDetailSheet(context),
          icon: const Icon(Icons.visibility),
          label: const Text('Afficher les détails'),
        ),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue.shade700,
            side: BorderSide(color: Colors.blue.shade700),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                Future.delayed(const Duration(seconds: 10), () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop(); // Ferme le dialog
                    Navigator.of(context).maybePop(); // Ferme la page si besoin
                  }
                });

                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  contentPadding: const EdgeInsets.only(
                    top: 16,
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(Icons.close, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Voici votre code sécurisé :", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          '123', // 👉 Remplace par carte.codeSecurite
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Ce code sera masqué automatiquement après 10 secondes.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.remove_red_eye_outlined),
          label: const Text('Voir le code'),
        ),


      ],
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title,
      String subtitle, String route,Carte carte,Client client) {
    return GestureDetector(
        onTap: () {
          context.push(
            route,
            extra: {
              'carte': carte,
              'client': client,
            },
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue.shade700),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        )
    );
  }
}
