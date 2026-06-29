import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../api/pret_api.dart';
import '../../models/client_model.dart';
import '../../models/pret_model.dart';
import '../../services/storage.dart';
import '../autres/custom_app_bar.dart';

class PretsPage extends StatefulWidget {
  final Client? client;
  const PretsPage({super.key, required this.client});

  @override
  State<PretsPage> createState() => _PretsPageState();
}

class _PretsPageState extends State<PretsPage> {
  List<Pret> prets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerPrets();
  }

  Future<void> _chargerPrets() async {
    final token = await StorageService.getAccessToken();
    if (token == null) return;

    final data = await PretApi.getPrets(token);
    setState(() {
      prets = data.map((json) => Pret.fromJson(json)).toList();
      isLoading = false;
    });
  }

  Color _couleurStatut(String statut) {
    switch (statut) {
      case 'en_attente':
        return Colors.orange;
      case 'approuve':
        return Colors.green;
      case 'refuse':
        return Colors.red;
      case 'annule':
        return Colors.grey;
      default:
        return Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: "Mes prêts",
        client: widget.client,
        showNotifications: false,
        onBack: () => context.push("/paiements", extra: {"client": widget.client}),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push("/prets/simulation", extra: {"client": widget.client});
        },
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Simuler un prêt", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : prets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text("Aucun prêt en cours",
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                      const SizedBox(height: 8),
                      const Text("Simulez un prêt pour commencer",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _chargerPrets,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: prets.length,
                    itemBuilder: (context, index) {
                      final pret = prets[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${pret.montantPret.toStringAsFixed(2)} €",
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _couleurStatut(pret.statut)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    pret.statutLabel,
                                    style: TextStyle(
                                      color: _couleurStatut(pret.statut),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _infoRow("Taux", "${pret.tauxInteret}%"),
                            _infoRow("Demandé le", f.format(pret.dateDemande)),
                            _infoRow("Échéance", f.format(pret.dateEcheance)),
                            if (pret.statut == 'en_attente') ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => _annulerPret(pret),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  child: const Text("Annuler la demande"),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _annulerPret(Pret pret) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Annuler ce prêt ?"),
        content: const Text("Cette action est irréversible."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Non")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Oui, annuler", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final token = await StorageService.getAccessToken();
    if (token == null) return;

    final success = await PretApi.annulerPret(token, pret.id);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Prêt annulé avec succès")),
      );
      _chargerPrets();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'annulation")),
      );
    }
  }
}
