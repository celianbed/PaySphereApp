import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import '../../../models/client_model.dart';
import '../../../providers/auth_providers.dart';

class CodeVerificationPage extends StatefulWidget {
  final Client client;
  final String titre;
  final String messageConfirmation;
  final VoidCallback? onSuccess;

  const CodeVerificationPage({
    super.key,
    required this.client,
    required this.titre,
    required this.messageConfirmation,
    this.onSuccess,
  });

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _validerCode() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    if(_codeController.text.isEmpty){
      setState(() {
        _error = 'Veuillez entrer un code';
        _isLoading = false;

      });
      return;
    }

    final isValid = await AuthProvider.verifierCode(
      widget.client.numClient.toString(),
      _codeController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (isValid && context.mounted) {
      widget.onSuccess?.call();

      context.push('/confirmation', extra: {
        'titre': widget.titre,
        'message': widget.messageConfirmation,
        'client': widget.client,
      });
    } else {
      setState(() {
        _error = 'Code incorrect. Veuillez réessayer.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: "Vérification",
        showNotifications: false,
        onBack:() => context.pop()),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 64, color: Colors.blueGrey),
                const SizedBox(height: 16),
                const Text(
                  "Confirmation requise",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Entrez votre code confidentiel pour confirmer cette action.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _codeController,
                  obscureText: true,
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Code confidentiel",
                    counterText: "",
                    prefixIcon: const Icon(Icons.password),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _validerCode,
                    icon: const Icon(Icons.check,color: Colors.white,),
                    label: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : const Text("Valider", style: TextStyle(fontSize: 16,color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
