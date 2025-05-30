import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/client_model.dart';

class NavigationWrapper extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Client? client;

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
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/accueil', extra: {
                "client" : client
              });
              break;
            case 1:
              context.go('/paiements',extra: {
                "client" : client
              });
              break;
            case 2:
              context.go('/contact',extra: {
              "client" : client
              });
              break;
            case 3:
              context.go('/profil',extra: {
                "client" : client
              });
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Paiements"),
          BottomNavigationBarItem(icon: Icon(Icons.contact_support), label: "Contact"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
