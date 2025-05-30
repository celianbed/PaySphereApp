import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../models/client_model.dart';
import '../../../models/virement_model.dart';
import '../../autres/custom_app_bar.dart';

class HistoriqueVirementsPage extends StatelessWidget {
  final Client? client;

  const HistoriqueVirementsPage({super.key, required this.client});


  List<Virement> _getAllVirements() {
    final virements = <Virement>[];
    for (final compte in client!.comptes) {
      virements.addAll(compte.virementEnvoye);
      virements.addAll(compte.virementRecu);
    }
    virements.sort((a, b) => b.date.compareTo(a.date));
    return virements;
  }

  @override
  Widget build(BuildContext context) {
    final virements = _getAllVirements();

      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomAppBar(
            title: 'Historique',
            showNotifications: true,
            onBack: () => context.pop(),
          ),
        ),
        body: virements.isEmpty
            ? const Center(
          child: Text(
            "Aucun virement pour l'instant.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: virements.length,
          itemBuilder: (context, index) {
            final virement = virements[index];
            final isEnvoye = virement.compteSourceNom.contains(client?.nom as Pattern);
            final color = isEnvoye ? Colors.blue.shade50 : Colors.green.shade50;
            final icon = isEnvoye ? Icons.arrow_upward : Icons.arrow_downward;
            final label = isEnvoye ? "Envoyé à" : "Reçu de";

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(icon, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$label ${isEnvoye ? virement.compteDestinataireNom : virement.compteSourceNom}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${virement.montant.toStringAsFixed(2)} €",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${virement.typeVirementNom} • ${virement.statutNom}",
                              style: TextStyle(
                                color: virement.statutNom.toLowerCase() == 'terminé'
                                    ? Colors.green.shade700
                                    : Colors.orange.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('dd/MM/yyyy', 'fr_FR').format(HttpDate.parse(virement.date)),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
  }
}
