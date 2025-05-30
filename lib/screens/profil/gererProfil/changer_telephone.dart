import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import '../../../api/client_api.dart';
import '../../../models/client_model.dart';
import '../../../services/storage.dart';

class ChangerTelephonePage extends StatefulWidget {
  final String numeroActuel;
  final Client client;

  const ChangerTelephonePage({
    super.key,
    required this.numeroActuel,
    required this.client,
  });

  @override
  State<ChangerTelephonePage> createState() => _ChangerTelephonePageState();
}

class _ChangerTelephonePageState extends State<ChangerTelephonePage> {
  final TextEditingController _numeroController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _numeroController.text = _formatNumero(widget.numeroActuel);
  }

  String _formatNumero(String numero) {
    final clean = numero.replaceAll(RegExp(r'\D'), '');
    final parts = RegExp(r'.{1,2}').allMatches(clean).map((m) => m.group(0)).toList();
    return parts.join('.');
  }

  bool _isValidFrenchPhone(String numero) {
    final regex = RegExp(r'^(0|\+33)[1-9](\d{8})$');
    final clean = numero.replaceAll(RegExp(r'\D'), '');
    return regex.hasMatch(clean.length == 10 ? clean : '+33${clean.substring(1)}');
  }

  void _soumettre() async {
    final numero = _numeroController.text.replaceAll(RegExp(r'\D'), '');

    if (!_isValidFrenchPhone(numero)) {
      setState(() {
        errorMessage = "Veuillez entrer un numéro français valide.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await StorageService.getAccessToken();
      final clientId = widget.client.id;

      final success = await ClientApi.miseAjourClient(
        clientId,
        {"numero": numero},
        token!,
        context
      );

      if (success && mounted) {
        widget.client.numeroDeTelephone = numero;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Numéro de téléphone mis à jour")),
        );
        context.pop();
      } else {
        setState(() {
          errorMessage = "Échec de la mise à jour. Veuillez réessayer.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Une erreur est survenue : $e";
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CustomAppBar(
        title: "Téléphone",
        showNotifications: false,
        onBack: () => context.pop(),
        client: widget.client,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nouveau numéro de téléphone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _numeroController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _TelephoneInputFormatter()
              ],
              decoration: InputDecoration(
                hintText: "06.12.34.56.78",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _soumettre,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Valider",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TelephoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final newText = RegExp(r'.{1,2}').allMatches(digits).map((m) => m.group(0)).join('.');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
