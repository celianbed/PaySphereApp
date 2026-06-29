import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../api/pret_api.dart';
import '../../models/client_model.dart';
import '../../services/storage.dart';
import '../autres/custom_app_bar.dart';

class SimulationPretPage extends StatefulWidget {
  final Client? client;
  const SimulationPretPage({super.key, required this.client});

  @override
  State<SimulationPretPage> createState() => _SimulationPretPageState();
}

class _SimulationPretPageState extends State<SimulationPretPage> {
  final TextEditingController _montantController = TextEditingController();
  int _dureeMois = 12;
  Map<String, dynamic>? _simulation;
  bool _isSubmitting = false;
  String? _erreur;

  final List<int> _durees = [12, 24, 36, 48, 60];

  void _simuler() {
    final montant = double.tryParse(_montantController.text);
    if (montant == null || montant <= 0) {
      setState(() => _erreur = "Veuillez entrer un montant valide.");
      return;
    }

    final result = PretApi.simuler(montant, _dureeMois);
    setState(() {
      if (result != null) {
        _simulation = result;
        _erreur = null;
      } else {
        _simulation = null;
        _erreur = "Vérifiez le montant (500€ – 75 000€).";
      }
    });
  }

  Future<void> _demanderPret() async {
    if (_simulation == null) return;

    setState(() => _isSubmitting = true);

    final token = await StorageService.getAccessToken();
    if (token == null) return;

    final montant = (_simulation!['montant'] as num).toDouble();
    final duree = (_simulation!['duree_mois'] as num).toInt();

    final result = await PretApi.creerPret(token, montant, duree);

    setState(() => _isSubmitting = false);

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Demande de prêt enregistrée")),
      );
      context.push("/prets", extra: {"client": widget.client});
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la demande")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: "Simuler un prêt",
        client: widget.client,
        showNotifications: false,
        onBack: () => context.push("/prets", extra: {"client": widget.client}),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Montant souhaité",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _montantController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Ex: 5000",
                      suffixText: "€",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Durée de remboursement",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: _durees.map((duree) {
                      final selected = duree == _dureeMois;
                      return ChoiceChip(
                        label: Text("$duree mois"),
                        selected: selected,
                        selectedColor: Colors.blue.shade100,
                        onSelected: (_) => setState(() => _dureeMois = duree),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _simuler,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Simuler",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            if (_erreur != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(_erreur!,
                            style: const TextStyle(color: Colors.red))),
                  ],
                ),
              ),
            ],
            if (_simulation != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Résultat de la simulation",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    _resultRow("Montant emprunté",
                        "${_simulation!['montant'].toStringAsFixed(2)} €"),
                    _resultRow("Durée", "${_simulation!['duree_mois']} mois"),
                    _resultRow(
                        "Taux d'intérêt", "${_simulation!['taux_interet']}%"),
                    const Divider(height: 24),
                    _resultRow("Mensualité",
                        "${_simulation!['mensualite'].toStringAsFixed(2)} €",
                        bold: true),
                    _resultRow("Coût total",
                        "${_simulation!['cout_total'].toStringAsFixed(2)} €"),
                    _resultRow("Coût des intérêts",
                        "${_simulation!['cout_interets'].toStringAsFixed(2)} €",
                        color: Colors.orange),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _demanderPret,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Text("Demander ce prêt",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Text(value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                fontSize: bold ? 18 : 15,
                color: color,
              )),
        ],
      ),
    );
  }
}
