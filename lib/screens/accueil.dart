import 'package:flutter/material.dart';
import 'login.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://img.freepik.com/photos-gratuite/personnes-appuyees-dans-bureau-debout_23-2147650958.jpg?t=st=1740874986~exp=1740878586~hmac=ee410c03e66702a68408605cd183c91b14d1e57bf5566fa3299243d8c87609ed&w=740',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay sombre pour assombrir l'image
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          // Contenu centré
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Sépare le titre et les boutons
              children: [
                const SizedBox(), // Espace vide pour centrer le texte

                // Titre et slogan centré
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'PAY SPHERE',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Votre argent, sans frontières',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                // Boutons en bas
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity, // Prend toute la largeur
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue.shade900,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 300), // Durée de la transition
                              pageBuilder: (context, animation, secondaryAnimation) => const Login(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0); // Départ à gauche
                                const end = Offset.zero;         // Arrivée à la position normale
                                const curve = Curves.easeIn;  // Courbe d'animation

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Accéder à mes comptes',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Moins d’espace entre les boutons
                    SizedBox(
                      width: double.infinity, // Prend toute la largeur
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue.shade700,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Devenir Client',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Espacement réduit
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Aide et services',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
