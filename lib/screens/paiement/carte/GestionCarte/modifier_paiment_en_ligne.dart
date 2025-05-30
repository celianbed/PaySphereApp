import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';

import '../../../../api/carte_api.dart';
import '../../../../models/carte_model.dart';
import '../../../../services/storage.dart';

class PaiementEnLignePage extends StatefulWidget {

  final Carte carte;

   const PaiementEnLignePage({super.key,required this.carte});

  @override
  State<PaiementEnLignePage> createState() => _PaiementEnLignePageState();
}

class _PaiementEnLignePageState extends State<PaiementEnLignePage> {

  late bool paimentEnLigne;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    paimentEnLigne = widget.carte.paimentEnLigne;
  }

  Future<void> togglePaiementEnLigne(bool newValue) async {
    setState(() => isLoading = true);

    String? token = await StorageService.getAccessToken();
    bool success = await CarteApi.setPaiementEnLigne(widget.carte.id, newValue, token ?? "");

    if (success && mounted) {
      setState(() {
        paimentEnLigne = newValue;
        widget.carte.paimentEnLigne = newValue;
      });
    }

    setState(() => isLoading = false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title:
      "Paiement en ligne",
        showNotifications: false,
        onBack: () => context.pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.desktop_windows, size: 64, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Activer les paiements en ligne',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text(
                      'Activez ou désactivez les paiements Internet, par téléphone et courrier. Les paiements en boutique et les retraits restent actifs.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Switch(
                  value: paimentEnLigne,
                  activeColor: Colors.blue.shade700,
                  onChanged: (value) => togglePaiementEnLigne(value)
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'La désactivation de ce service permet de limiter les risques de fraude à la carte bancaire.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                Text(
                  'Attention : tous vos paiements automatiques (abonnements, vidéos à la demande, etc.) seront suspendus jusqu’à réactivation.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
