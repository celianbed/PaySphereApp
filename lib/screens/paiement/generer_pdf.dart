import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<File> generateStyledRIBPdf({
  required String nom,
  required String? iban,
  required String? bic,
  required String codeBanque,
  required String? codeAgence,
  required String numeroCompte,
  required String cleRib,
  required String? agence,
}) async {
  final pdf = pw.Document();

  final titleStyle = pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold);
  final labelStyle = pw.TextStyle(fontSize: 12, color: PdfColors.grey700);
  final valueStyle = pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Relevé d’Identité Bancaire (RIB)', style: titleStyle),
            pw.SizedBox(height: 20),

            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blueGrey, width: 1),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Titulaire du compte', style: labelStyle),
                  pw.Text(nom, style: valueStyle),
                  pw.SizedBox(height: 10),

                  pw.Text('IBAN', style: labelStyle),
                  pw.Text(iban!, style: valueStyle),
                  pw.SizedBox(height: 10),

                  pw.Text('BIC / SWIFT', style: labelStyle),
                  pw.Text(bic!, style: valueStyle),
                  pw.SizedBox(height: 20),

                  pw.Text('Informations bancaires', style: labelStyle),
                  pw.SizedBox(height: 6),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Code banque : $codeBanque", style: valueStyle),
                      pw.Text("Code agence : $codeAgence", style: valueStyle),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("N° compte : $numeroCompte", style: valueStyle),
                      pw.Text("Clé RIB : $cleRib", style: valueStyle),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  pw.Text('Agence de domiciliation', style: labelStyle),
                  pw.Text(agence!, style: valueStyle),
                ],
              ),
            ),

            pw.SizedBox(height: 40),
            pw.Divider(),
            pw.Text('Document généré automatiquement via PaySphere.',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          ],
        );
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/RIB_${nom.replaceAll(' ', '_')}.pdf');
  await file.writeAsBytes(await pdf.save());

  return file;
}
