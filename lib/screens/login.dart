import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/api/api_client.dart';
import 'package:pay_sphere_app/providers/client_provider.dart';
import 'package:pay_sphere_app/providers/auth_providers.dart';
import '../main.dart';
import '../models/client_model.dart';
import '../services/notification_service.dart';
import '../services/storage.dart';

class LoginPage extends StatefulWidget {
  /// Client mémorisé lors d'une session précédente, s'il y en a un.
  ///
  /// Valeur initiale uniquement : le client courant évolue pendant la
  /// connexion et appartient donc à l'état, pas au widget. Un champ mutable
  /// dans un `StatefulWidget` est ignoré lors des reconstructions et ne
  /// déclenche aucun rafraîchissement.
  final Client? clientInitial;

  const LoginPage({super.key, required this.clientInitial});

  @override
  Login createState() => Login();
}

class Login extends State<LoginPage> {
  final TextEditingController clientNumberController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool isCodeVisible = false;
  bool isSwitchOn = false;
  bool isLoading = false;
  bool obsureText = true;


  String? errorMessage;

  /// Message affiché lorsque l'instance d'hébergement doit être réveillée.
  /// Sans ce retour visuel, l'utilisateur fait face à un écran figé pendant
  /// une minute et conclut que l'application est plantée.
  String? messageReveil;

  /// Client courant : issu de la session mémorisée, puis rechargé après
  /// authentification.
  Client? client;

  @override
  void initState() {
    super.initState();
    client = widget.clientInitial;
    ApiClient.onReveilServeur = () {
      if (mounted) {
        setState(() {
          messageReveil =
              "Réveil du serveur en cours, cela peut prendre jusqu'à une minute...";
        });
      }
    };
    _loadClientSavedInfos();
  }

  @override
  void dispose() {
    ApiClient.onReveilServeur = null;
    clientNumberController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Future<void> _loadClientSavedInfos() async {
    if (client != null) {
      setState(() {
        clientNumberController.text = client!.numClient.toString();
      });
      isCodeVisible = true;

    }
  }
    Future<void> saveClient() async {
      await StorageService.setClient(client);
    }
    void checkClientNumber() {
      setState(() {
        if (clientNumberController.text.length >= 6) {
          isCodeVisible = true;
        }
      });
    }
    Future<void> fetchClient(String numClient, String token) async {
      final clientProvider = ClientProvider();
      await clientProvider.loadClient(int.tryParse(numClient), token);
      setState(() {
        client = clientProvider.client;
      });
    }

    void showErrorDialog(String title, String message) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/images/first.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: () => context.push("/demarrage", extra: client),
                child: const Icon(
                  Icons.chevron_left,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Connexion',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: clientNumberController,
                      onChanged: (value) => checkClientNumber(),
                      maxLength: 9,
                      decoration: InputDecoration(
                        labelText: 'Numéro client',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                            Icons.person, color: Colors.blue.shade700),
                      ),
                    ),
                    if (isCodeVisible) ...[
                      const SizedBox(height: 15),
                      TextField(
                        controller: codeController,
                        obscureText: obsureText,
                        decoration: InputDecoration(
                          labelText: 'Code secret',
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(
                              Icons.lock, color: Colors.blue.shade700),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obsureText ? Icons.visibility_off_sharp : Icons
                                  .visibility,
                              color: Colors.blue.shade700,
                            ),
                            onPressed: () {
                              setState(() {
                                obsureText = !obsureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 15),
                    if (client == null)
                      Row(
                        children: [
                          Text(
                            'Mémoriser mon numéro client',
                            style: TextStyle(color: Colors.blue.shade800),
                          ),
                          const Spacer(),
                          Switch(
                            value: isSwitchOn,
                            onChanged: (bool value) {
                              setState(() {
                                isSwitchOn = value;
                              });
                            },
                            activeColor: Colors.blue.shade700,
                          )
                        ],
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue.shade700,
                        elevation: 5,
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });

                        final numClient = clientNumberController.text;
                        final code = codeController.text;

                        if (numClient.isEmpty || code.isEmpty) {
                          showErrorDialog("Champs requis", "Veuillez entrer votre numéro client et votre code secret.");
                          setState(() => isLoading = false);
                          return;
                        }

                        try {
                          // L'instance gratuite s'arrête après quinze minutes
                          // sans trafic ; on la réveille avant d'envoyer les
                          // identifiants, en informant l'utilisateur plutôt
                          // qu'en échouant sur un délai trop court.
                          final serveurPret = await ApiClient.reveillerServeur();
                          if (!serveurPret) {
                            showErrorDialog(
                              "Serveur injoignable",
                              "Le serveur n'a pas répondu. Vérifiez votre connexion "
                              "puis réessayez dans quelques instants.",
                            );
                            setState(() {
                              isLoading = false;
                              messageReveil = null;
                            });
                            return;
                          }

                          final auth = AuthProvider();
                          final isLoggedIn = await auth.login(numClient, code);

                          if (!isLoggedIn) {
                            showErrorDialog("Erreur de connexion", "Identifiants incorrects ou erreur serveur. Vérifiez votre numéro client et votre code secret.");
                            setState(() => isLoading = false);
                            return;
                          }

                          final token = await StorageService.getAccessToken();
                          if (token == null) {
                            showErrorDialog("Erreur", "Token d'accès non disponible après authentification.");
                            setState(() => isLoading = false);
                            return;
                          }

                          await fetchClient(numClient, token);
                          await saveClient();

                          if (context.mounted) {
                            await NotificationService.initialize(
                                flutterLocalNotificationsPlugin, navigatorKey);
                            context.push('/accueil', extra: {
                               "client" : client
                            });
                          }

                          codeController.clear();
                        } on SocketException {
                          showErrorDialog("Connexion impossible", "Vérifiez votre connexion réseau ou que le serveur est bien lancé.");
                        } on TimeoutException {
                          showErrorDialog("Serveur injoignable",
                              "Le serveur met trop de temps à répondre. Réessayez dans quelques instants.");
                        } catch (e) {
                          showErrorDialog("Erreur inattendue", "Une erreur est survenue : $e");
                        } finally {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                              messageReveil = null;
                            });
                          }
                        }
                      },

                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Continuer',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    if (messageReveil != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              messageReveil!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }