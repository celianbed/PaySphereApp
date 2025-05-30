import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/models/beneficiare_model.dart';
import 'package:pay_sphere_app/models/client_model.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import '../../../api/virement_api.dart';
import '../../../services/storage.dart';

class NouveauVirementPage extends StatefulWidget {
  final Client? client;

  const NouveauVirementPage({super.key, required this.client});

  @override
  State<NouveauVirementPage> createState() => _NouveauVirementPageState();
}

class _NouveauVirementPageState extends State<NouveauVirementPage> {
  List<Beneficiaire> beneficiaires = [];
  String? selectedIban;
  final TextEditingController montantController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    beneficiaires = widget.client!.beneficiaires;
  }


  void envoyerVirement() async {
    final montant = double.tryParse(montantController.text);

    if (selectedIban == null || montant == null || montant <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner un bénéficiaire et entrer un montant valide.")),
      );
      return;
    }

    setState(() => isLoading = true);

    final token = await StorageService.getAccessToken();
    final fromAccountId = widget.client?.comptes[0].id;
    final toAccountIban = selectedIban!;

    final peutContinuer = await VirementApi.verifierBeneficiaire(
        selectedIban!,
        token!
    );

    if (!peutContinuer) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Virement impossible. Bénéficiaire inexistant ou fonds insuffisants.")),
      );
      return;
    }
    context.push('/verifier_code', extra: {
      'client': widget.client,
      'titre': 'Vérification',
      'message': 'Veuillez confirmer votre virement.',
      'onSuccess': () async {
        final success = await VirementApi.transfer(token, fromAccountId!, toAccountIban, montant);

        if (success && context.mounted) {
          widget.client?.comptes[0].solde -= montant;

          context.push('/confirmation', extra: {
            'titre': 'Virement effectué',
            'message': 'Virement de $montant € effectué avec succès.',
            'client': widget.client,
            'futurePush': '/virements'
          });
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Échec du virement.")),
            );
            context.go('/virements');
          }
        }
      }
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: "Nouveau Virement",
        onBack: () => context.push("/virements",extra: {
          "client": widget.client
        }),
        showNotifications: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choisissez un bénéficiaire",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: beneficiaires.length,
                itemBuilder: (_, index) {
                  final b = beneficiaires[index];
                  final isSelected = selectedIban == b.iban;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedIban = b.iban);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_circle_rounded, color: Colors.blue.shade700, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(b.nom, style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text("IBAN : ${b.iban}", style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Colors.blue)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Montant à envoyer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: montantController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.euro),
                hintText: "Ex: 120.00",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: envoyerVirement,
                icon: const Icon(Icons.send_rounded, size: 20, color: Colors.white),
                label: const Text("Envoyer le virement", style: TextStyle(fontSize: 16,color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
