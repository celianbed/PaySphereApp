import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/api/api_client.dart';
import 'package:pay_sphere_app/models/beneficiare_model.dart';
import 'package:pay_sphere_app/models/client_model.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import 'package:pay_sphere_app/services/storage.dart';

import '../../../api/client_api.dart';

class AjouterBeneficiairePage extends StatefulWidget {

  final Client? client;

   const AjouterBeneficiairePage({super.key,required this.client});

  @override
  State<AjouterBeneficiairePage> createState() => _AjouterBeneficiairePageState();
}

class _AjouterBeneficiairePageState extends State<AjouterBeneficiairePage> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();
  bool isLoading = false;
  List<Beneficiaire>? beneficiaires = [];

  @override
  void initState() {
    super.initState();
    beneficiaires = widget.client?.beneficiaires;
  }

  Future<void> ajouterBeneficiaire() async {
    final nom = nomController.text.trim();
    final iban = ibanController.text.trim();

    if (nom.isEmpty || iban.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    setState(() => isLoading = true);
    final token = await StorageService.getAccessToken();

    final data = await ApiClient.post(
      "/clients/beneficiaires",
      {"nom": nom, "iban": iban},
      token: token,
    );

    setState(() => isLoading = false);

    if (data != null && data["message"] != null) {
      final nouveau = Beneficiaire(
        nom: nom,
        iban: iban,
        clientId: widget.client!.id,
      );

      setState(() {
        beneficiaires?.add(nouveau);
        widget.client?.beneficiaires = beneficiaires!;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"])),
      );
      nomController.clear();
      ibanController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data?["error"] ?? "Erreur inconnue")),
      );
    }
  }


  Future<void> supprimerBeneficiaire(int? id) async {
    final token = await StorageService.getAccessToken();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Voulez-vous vraiment supprimer ce bénéficiaire ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Supprimer")),
        ],
      ),
    );

    if (confirm != true) return;

    final response = await ClientApi.supprimerBeneficiaire(id!, token!);

    if (response != null && response["message"] != null) {
      setState(() {
        beneficiaires?.removeWhere((b) => b.id == id);
        widget.client?.beneficiaires = beneficiaires!;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response?["error"] ?? "Échec de la suppression")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: "Bénéficiaires",
        showNotifications: false,
        onBack: () => context.push("/virements",extra: {
          "client" :widget.client
        }),
      ),
      body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ajouter un bénéficiaire", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: nomController,
                decoration: InputDecoration(
                  hintText: "Nom du bénéficiaire",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ibanController,
                decoration: InputDecoration(
                  hintText: "IBAN",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : ajouterBeneficiaire,
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text(isLoading ? "Ajout..." : "Ajouter le bénéficiaire"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const Divider(height: 40),
              const Text("Liste des bénéficiaires", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...?beneficiaires?.map((b) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(b.nom),
                  subtitle: Text(b.iban),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => supprimerBeneficiaire(b.id),
                  ),
                ),
              )),
              if (beneficiaires!.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("Aucun bénéficiaire pour le moment."),
                ),
            ],
          ),
        ),
    );
  }
}
