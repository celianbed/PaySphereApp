import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pay_sphere_app/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pay_sphere_app/providers/auth_providers.dart';
import 'package:pay_sphere_app/screens/demarrage.dart';

import '../api/clientApp_api.dart';
import '../services/storage.dart';
import 'accueil.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final TextEditingController clientNumberController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool isCodeVisible = false;
  bool isSwitchOn = false;
  bool isNumberSaved = false;
  String? isLogin;


  @override
  void initState() {
    super.initState();
    _loadClientNumber();
  }


  Future<void> _loadClientNumber() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin = await StorageService.getIsLogin();
    String? savedNumber = prefs.getString('client_number');

    if (savedNumber != null) {
      setState(() {
        clientNumberController.text = savedNumber;
        isNumberSaved = true;
      });
    }
    if (isLogin == "true") {
      isCodeVisible = true;
    }
  }

  Future<void> _saveClientNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('client_number', clientNumberController.text);
    setState(() {
      isNumberSaved = true;
    });
  }

  void checkClientNumber() {
    setState(() {
      if (clientNumberController.text.length >= 6) {
        isCodeVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:AssetImage("lib/assets/images/first.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
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
                color: Colors.white.withOpacity(0.95),
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
                    maxLength: 99,
                    decoration: InputDecoration(
                      labelText: 'Numéro client',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.blue.shade700),
                    ),
                  ),
                  if (isCodeVisible) ...[
                    const SizedBox(height: 15),
                    TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                        labelText: 'Code secret',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                      ),
                    ),
                  ],
                  const SizedBox(height: 15),
                  if (!isNumberSaved)
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
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue.shade700,
                      elevation: 5,
                    ),
                    onPressed: () async {
                      String numClient = clientNumberController.text;
                      String code = codeController.text;

                      if (numClient.isNotEmpty && code.isNotEmpty) {
                        AuthProvider auth = AuthProvider();
                        bool isLoggedIn = await auth.login(numClient, code);

                        if (isLoggedIn) {
                          // Récupérer les informations du client

                          String? token = await StorageService.getAccessToken();
                          await StorageService.setClientNumber(numClient, isSwitchOn);

                          Map<dynamic, dynamic>? clientInfo = await ClientAppApi.getClientInfo(int.tryParse(numClient),token!,fields: "nom,prenom,num_client");

                          if (clientInfo != null) {
                            // Stocker les informations localement
                            await StorageService.setClientName(clientInfo['nom'], clientInfo['prenom']);

                          }
                          if (isSwitchOn) {
                            await _saveClientNumber();
                            await StorageService.saveIsLogin("true");

                          }

                          // Rediriger vers la page de démarrage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AccueilPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Connexion échouée. Vérifiez vos informations.")),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Continuer',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}