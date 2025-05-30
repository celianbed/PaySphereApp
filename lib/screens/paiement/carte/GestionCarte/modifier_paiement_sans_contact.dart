import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';

import '../../../../api/carte_api.dart';
import '../../../../models/carte_model.dart';
import '../../../../services/storage.dart';

class PaiementSansContactPage extends StatefulWidget {

  final Carte carte;

  const PaiementSansContactPage({super.key,required this.carte});

  @override
  State<PaiementSansContactPage> createState() => _PaiementSansContactPageState();
}

class _PaiementSansContactPageState extends State<PaiementSansContactPage> {

  late bool paimentSansContact ;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    paimentSansContact = widget.carte.paimentSansContact;
  }

  Future<void> togglePaiementSansContact(bool newValue) async {
    setState(() => isLoading = true);

    String? token = await StorageService.getAccessToken();
    bool success = await CarteApi.setPaiementSansContact(widget.carte.id, newValue, token ?? "");

    if (success && mounted) {
      setState(() {
        paimentSansContact = newValue;
        widget.carte.paimentSansContact = newValue;
      });
    }
    setState(() => isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: "Paiement sans con..",
      showNotifications: false,
      onBack: () => context.pop()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.contactless, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Activer le paiement sans contact',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text(
                      'Autorisez ou bloquez les paiements sans contact,\nquand vous le souhaitez.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Switch(
                value: paimentSansContact,
                activeColor: Colors.blue.shade700,
                onChanged: (value) => togglePaiementSansContact(value)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
