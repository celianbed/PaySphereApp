import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Transitions de pages, regroupées ici pour rester cohérentes d'un écran à
/// l'autre et éviter de répéter le même bloc d'animation dans chaque route.

/// Durée d'un changement d'onglet : assez court pour ne jamais retarder
/// l'utilisateur, assez long pour que l'œil suive.
const Duration _dureeFondu = Duration(milliseconds: 170);

/// Durée d'une descente dans la hiérarchie, légèrement plus longue : le
/// mouvement porte une information de direction.
const Duration _dureeGlissement = Duration(milliseconds: 280);

/// Page d'onglet : simple fondu.
///
/// Les onglets du menu inférieur sont des frères — aucun n'est « après » un
/// autre. Un glissement suggérerait une hiérarchie qui n'existe pas ; le
/// fondu, lui, se contente d'adoucir le changement.
CustomTransitionPage<void> pageFondu({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: _dureeFondu,
    reverseTransitionDuration: _dureeFondu,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

/// Page de détail : glissement depuis la droite, accompagné d'un fondu.
///
/// La courbe `easeOutCubic` démarre vite et freine à l'arrivée, ce qui donne
/// un mouvement plus naturel qu'un `easeInOut` symétrique.
CustomTransitionPage<void> pageGlissee({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: _dureeGlissement,
    reverseTransitionDuration: _dureeGlissement,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final adoucie = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(adoucie),
        child: FadeTransition(opacity: adoucie, child: child),
      );
    },
  );
}
