import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/client_model.dart';

class NavigationWrapper extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Client? client; // 👈 Ajoute ceci


  const NavigationWrapper({
    super.key,
    required this.child,
    required this.currentIndex,
    this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue.shade500,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/accueil', extra: client);
              break;
            case 1:
              context.go('/paiements',extra: client);
              break;
            case 2:
              context.go('/decouvrir');
              break;
            case 3:
              context.go('/contact');
              break;
            case 4:
              context.go('/profil');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Paiements"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Découvrir"),
          BottomNavigationBarItem(icon: Icon(Icons.contact_support), label: "Contact"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
