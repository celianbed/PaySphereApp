import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import '../../../api/client_api.dart';
import '../../../models/client_model.dart';
import '../../../services/storage.dart';

class ChangerEmailPage extends StatefulWidget {
  final String emailActuel;
  final Client client;

  const ChangerEmailPage({
    super.key,
    required this.emailActuel,
    required this.client,
  });

  @override
  State<ChangerEmailPage> createState() => _ChangerEmailPageState();
}

class _ChangerEmailPageState extends State<ChangerEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.emailActuel;
  }

  void _soumettre() async {
    final newEmail = _emailController.text.trim();

    if (newEmail.isEmpty || !newEmail.contains('@')) {
      setState(() => errorMessage = "Veuillez entrer un email valide.");
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await StorageService.getAccessToken();

      if (mounted) {
        context.push('/verifier_code', extra: {
          'client': widget.client,
          'titre': 'Vérification de l\'email',
          'message': 'Un code a été envoyé à $newEmail',
          'onSuccess': () async {
            final clientId = widget.client.id;
            final updateSuccess = await ClientApi.miseAjourClient(
              clientId,
              {"email": newEmail},
              token!,
              context,
            );

            if (updateSuccess && context.mounted) {
              widget.client.email = newEmail;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Adresse email mise à jour")),
              );

              context.push('/confirmation', extra: {
                'titre': 'Changement de mail',
                'message': 'Votre mail $newEmail a été ajouté avec succès',
                'client': widget.client,
                'futurePush':'/profil'
              });
            }
          }
        });
      }
    } catch (e) {
      setState(() => errorMessage = "Une erreur est survenue : $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CustomAppBar(
        title: "Adresse Mail",
        showNotifications: false,
        onBack: () => context.pop(),
        client: widget.client,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nouvelle adresse email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "exemple@email.com",
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
                child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
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
                    : const Text("Valider", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
