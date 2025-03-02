import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void checkClientNumber() {
    setState(() {
      isCodeVisible = clientNumberController.text.length >= 6;
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
                image: NetworkImage(
                    'https://img.freepik.com/photos-gratuite/personnes-appuyees-dans-bureau-debout_23-2147650958.jpg?t=st=1740874986~exp=1740878586~hmac=ee410c03e66702a68408605cd183c91b14d1e57bf5566fa3299243d8c87609ed&w=740'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          // Bouton retour
          Positioned(
            top: 50, // Ajuste pour éviter le notch
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

          // Carte de connexion
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
                    maxLength: 8,
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
                    obscureText: true, // Cache le texte
                    keyboardType: TextInputType.number, // Clavier numérique
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Autorise uniquement les chiffres
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
                      obscureText: true, // Cache le texte
                      keyboardType: TextInputType.number, // Clavier numérique
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Autorise uniquement les chiffres
                    ),
                  ],
                  const SizedBox(height: 15),
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
                    onPressed: () {},
                    child: const Text(
                      'Continuer',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Numéro client ou code secret oublié ?',
                      style: TextStyle(fontSize: 16, color: Colors.blue.shade800),
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

