import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/autres/custom_app_bar.dart';
import '../../../api/client_api.dart';
import '../../../models/client_model.dart';
import '../../../services/storage.dart';

class ChangerMotDePassePage extends StatefulWidget {
  final Client client;

  const ChangerMotDePassePage({super.key, required this.client});

  @override
  State<ChangerMotDePassePage> createState() => _ChangerMotDePassePageState();
}

class _ChangerMotDePassePageState extends State<ChangerMotDePassePage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  // Vérifie si le mot de passe respecte les critères de sécurité
  bool _isPasswordValid(String password) {
    final hasMinLength = password.length >= 8;
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'\d'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasMinLength && hasUpper && hasLower && hasDigit && hasSpecial;
  }

  // Soumet les données pour changer le mot de passe
  Future<void> _soumettre() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Vérifie si tous les champs sont remplis
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => errorMessage = "Tous les champs sont requis.");
      return;
    }

    // Vérifie si le nouveau mot de passe est valide
    if (!_isPasswordValid(newPassword)) {
      setState(() => errorMessage =
      "Le nouveau mot de passe doit contenir au moins 8 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial.");
      return;
    }

    // Vérifie si les mots de passe correspondent
    if (newPassword != confirmPassword) {
      setState(() => errorMessage = "Les mots de passe ne correspondent pas.");
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Récupère le token d'accès pour l'authentification
      final token = await StorageService.getAccessToken();

      // Appelle l'API pour changer le mot de passe
      final success = await ClientApi.changerMotDePasse(
        userId: widget.client.userId,
        ancienPassword: oldPassword,
        nouveauPassword: newPassword,
        token: token!,
      );

      // Gère les différents cas de succès ou d'échec
      if (!success) {
        setState(() {
          errorMessage = "Ancien mot de passe incorrect.";
          isLoading = false;
        });
        return;
      }

      if (success && mounted) {
        // Affiche un message de succès et retourne à la page précédente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mot de passe mis à jour")),
        );
        Navigator.pop(context);
      } else {
        setState(() => errorMessage = "Échec de la mise à jour. Veuillez réessayer.");
      }
    } catch (e) {
      // Capture et affiche les erreurs inattendues
      setState(() => errorMessage = "Une erreur est survenue : $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CustomAppBar(
        title: "Changer mot de passe",
        showNotifications: false,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ancien mot de passe",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  hintText: "********",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const Text("Nouveau mot de passe",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "********",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                keyboardType: TextInputType.text,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  hintText: "Confirmez le mot de passe",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                obscureText: true,
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(errorMessage!,
                      style: const TextStyle(color: Colors.red)),
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
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Valider",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}