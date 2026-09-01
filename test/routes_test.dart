import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/autres/register.dart';
import 'package:pay_sphere_app/screens/demarrage.dart';
import 'package:pay_sphere_app/screens/login.dart';
import 'package:pay_sphere_app/utils/routes.dart';

/// Un rechargement de page — redémarrage à chaud, retour depuis
/// l'arrière-plan, rafraîchissement sur le web — reconstruit la route à partir
/// de l'URL seule. `GoRouterState.extra` n'étant pas porté par l'URL, il vaut
/// alors `null`.
///
/// Chaque `pageBuilder` doit supporter ce cas : soit en restaurant ce dont il a
/// besoin, soit en redirigeant vers un écran atteignable. Aucun ne doit lever
/// d'exception.
void main() {
  /// Toutes les routes de l'application, hormis `/` qui héberge l'écran de
  /// démarrage : celui-ci initialise des greffons indisponibles sous test.
  const routes = <String>[
    '/demarrage',
    '/login',
    '/register',
    '/accueil',
    '/paiements',
    '/paiements/cartes',
    '/paiements/cartes/details-carte',
    '/paiements/cartes/details-carte/opposition',
    '/paiements/cartes/details-carte/plafonds',
    '/paiements/cartes/details-carte/plafonds/modifier-plafond',
    '/paiements/cartes/details-carte/modifier-paimement-en-ligne',
    '/paiements/cartes/details-carte/modifier-paimement-sans-contact',
    '/verifier_code',
    '/confirmation',
    '/rib',
    '/cheques',
    '/contact',
    '/virements',
    '/virements/nouveau-virement',
    '/virements/beneficiaires',
    '/virements/historique',
    '/profil',
    '/notifications',
    '/detailsCompte',
    '/modifier-email',
    '/modifier-tel',
    '/prets',
    '/prets/simulation',
    '/modifier-mdp',
  ];

  for (final chemin in routes) {
    testWidgets('$chemin se reconstruit sans extra', (tester) async {
      final router = GoRouter(
        initialLocation: chemin,
        routes: Routes.routerConfiguration().configuration.routes,
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pump();

      expect(
        tester.takeException(),
        isNull,
        reason: '$chemin lève une exception quand extra est absent',
      );
    });
  }

  // Les écrans d'avant connexion se construisent sans client. Vérifier
  // seulement qu'ils ne lèvent pas d'exception ne suffit pas : une
  // redirection vers /login ne lève rien et vide l'écran de son contenu.
  final ecransPublics = <String, Type>{
    '/demarrage': DemarragePage,
    '/login': LoginPage,
    '/register': RegisterPage,
  };

  ecransPublics.forEach((chemin, ecran) {
    testWidgets('$chemin affiche $ecran sans client', (tester) async {
      final router = GoRouter(
        initialLocation: chemin,
        routes: Routes.routerConfiguration().configuration.routes,
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pump();

      expect(
        find.byType(ecran),
        findsOneWidget,
        reason: '$chemin ne doit pas rediriger : il précède la connexion',
      );
    });
  });
}
