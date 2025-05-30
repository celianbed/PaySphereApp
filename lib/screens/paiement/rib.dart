import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/client_model.dart';
import 'generer_pdf.dart';

class RIBPage extends StatelessWidget {
  final Client? client;

  const RIBPage({super.key, required this.client});

  Future<File> _genererPDF({
    required String nom,
    required String iban,
    required String bic,
    required String codeBanque,
    required String codeAgence,
    required String numeroCompte,
    required String cleRib,
    required String agence,
  }) async {
    final fileTemp = await generateStyledRIBPdf(
      nom: nom,
      iban: iban,
      bic: bic,
      codeBanque: codeBanque,
      codeAgence: codeAgence,
      numeroCompte: numeroCompte,
      cleRib: cleRib,
      agence: agence,
    );

    final outputDir = Directory('/storage/emulated/0/Download');
    final finalPath = "${outputDir.path}/RIB_${nom.replaceAll(" ", "_")}.pdf";
    final finalFile = File(finalPath);

    await fileTemp.copy(finalFile.path);
    return finalFile;
  }

  Future<void> _telechargerRIB(BuildContext context, Map<String?, String?> data) async {
    final file = await _genererPDF(
      nom: data['nom']!,
      iban: data['iban']!,
      bic: data['bic']!,
      codeBanque: data['codeBanque']!,
      codeAgence: data['codeAgence']!,
      numeroCompte: data['numeroCompte']!,
      cleRib: data['cleRib']!,
      agence: data['agence']!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("RIB téléchargé dans : ${file.path}")),
    );
  }

  Future<void> _partagerRIB(BuildContext context, Map<String?, String?> data) async {
    final file = await _genererPDF(
      nom: data['nom']!,
      iban: data['iban']!,
      bic: data['bic']!,
      codeBanque: data['codeBanque']!,
      codeAgence: data['codeAgence']!,
      numeroCompte: data['numeroCompte']!,
      cleRib: data['cleRib']!,
      agence: data['agence']!,
    );

    Share.shareXFiles([XFile(file.path)], text: 'Voici mon RIB.');
  }

  void copyToClipboard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copié dans le presse-papiers')),
    );
  }

  Widget buildLine(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () => copyToClipboard(context, value),
            )
          ],
        ),
        const Divider()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final nom = "${client?.prenom} ${client?.nom}";
    final iban = client?.comptes[0].rib!.iban;
    final bic = client?.comptes[0].rib!.bic;
    final codeBanque = "3000";
    final codeAgence = "6000";
    final numeroCompte = client?.comptes[0].numeroCompte.toString();
    final cleRib = "01";
    final agence = "${client?.comptes[0].rib!.adresseBanque}";

    final data = {
      'nom': nom,
      'iban': iban,
      'bic': bic,
      'codeBanque': codeBanque,
      'codeAgence': codeAgence,
      'numeroCompte': numeroCompte,
      'cleRib': cleRib,
      'agence': agence,
    };

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar:CustomAppBar(title: "RIB",
        onBack: () =>  context.pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildLine(context, "Titulaire du compte", nom),
          buildLine(context, "IBAN", iban!),
          buildLine(context, "BIC", bic!),
          const SizedBox(height: 8),
          const Text("Coordonnées bancaires",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: buildLine(context, "Code banque", codeBanque)),
              Expanded(child: buildLine(context, "Code agence", codeAgence)),
            ],
          ),
          Row(
            children: [
              Expanded(child: buildLine(context, "N° de compte", numeroCompte!)),
              Expanded(child: buildLine(context, "Clé RIB", cleRib)),
            ],
          ),
          buildLine(context, "Agence de domiciliation", agence),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _partagerRIB(context, data),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.share, color: Colors.white),
            label: const Text("Partager le RIB",
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: () => _telechargerRIB(context, data),
              icon: const Icon(Icons.download_rounded, color: Colors.blue),
              label: const Text("Télécharger le RIB",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );
  }
}
