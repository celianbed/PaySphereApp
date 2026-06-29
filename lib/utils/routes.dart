import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/screens/acceuil/accueil.dart';
import 'package:pay_sphere_app/screens/autres/register.dart';
import 'package:pay_sphere_app/screens/demarrage.dart';
import 'package:pay_sphere_app/screens/autres/notifications.dart';
import 'package:pay_sphere_app/screens/paiement/carte/GestionCarte/modifier_paiement_sans_contact.dart';
import 'package:pay_sphere_app/screens/paiement/carte/GestionCarte/modifier_plafond.dart';
import 'package:pay_sphere_app/screens/paiement/carte/GestionCarte/plafonds.dart';
import 'package:pay_sphere_app/screens/paiement/paiements.dart';
import 'package:pay_sphere_app/screens/paiement/virements/historique.dart';
import 'package:pay_sphere_app/screens/paiement/virements/nouveau_virement.dart';
import 'package:pay_sphere_app/screens/profil/gererProfil/changer_mail.dart';
import 'package:pay_sphere_app/screens/profil/gererProfil/changer_mdp.dart';
import 'package:pay_sphere_app/screens/profil/gererProfil/changer_telephone.dart';
import 'package:pay_sphere_app/screens/profil/profil.dart';

import '../main.dart';
import '../models/carte_model.dart';
import '../models/client_model.dart';
import '../screens/autres/confirmation_code_page.dart';
import '../screens/autres/confirmation_page.dart';
import '../screens/contact/contact.dart';
import '../screens/acceuil/details_compte.dart';
import '../screens/login.dart';
import '../screens/paiement/carte/GestionCarte/modifier_paiment_en_ligne.dart';
import '../screens/paiement/carte/GestionCarte/opposition.dart';
import '../screens/paiement/carte/cartes.dart';
import '../screens/paiement/carte/detail_carte.dart';
import '../screens/paiement/cheques.dart';
import '../screens/paiement/rib.dart';
import '../screens/paiement/virement.dart';
import '../screens/paiement/virements/gerer_beneficaire.dart';
import '../screens/pret/prets_page.dart';
import '../screens/pret/simulation_pret_page.dart';

class Routes {
  static GoRouter routerConfiguration({GlobalKey<NavigatorState>? navigatorKey}) {
    return GoRouter(
      navigatorKey: navigatorKey,
      routes: <RouteBase>[
        GoRoute(
          path: '/demarrage',
          pageBuilder: (context, state) {
            Client? client = state.extra as Client?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: DemarragePage(client: client),
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                final tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: curve));
                final offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            );
          },
        ),

        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            Client? client = state.extra as Client?;

            return CustomTransitionPage(
              key: state.pageKey,
              child: LoginPage(client: client),
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                final tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: curve));
                final offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/accueil',
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client;
            return NoTransitionPage(
              key: state.pageKey,
              child: AccueilPage(client: client),
            );
          },
        ),

        GoRoute(
          path: "/register",
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: RegisterPage(),
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                final tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: curve));
                final offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/paiements',
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client;
            return NoTransitionPage(
              key: state.pageKey,
              child: PaiementsPage(client: client),
            );
          },
        ),
        GoRoute(
          path: '/paiements/cartes',
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client;

            return NoTransitionPage(
              key: state.pageKey,
              child: CartesPage(client: client),
            );
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final carte = extras['carte'] as Carte;
            final client = extras['client'] as Client;
            return CarteDetailPage(carte: carte, client: client);
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte/opposition',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final carte = extras['carte'] as Carte;
            final client = extras['client'] as Client;

            return OppositionPage(carte: carte, client: client);
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte/plafonds',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final carte = extras['carte'] as Carte;
            final client = extras['client'] as Client;

            return CartePlafondPage(carte: carte, client: client);
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte/plafonds/modifier-plafond',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final carte = extras['carte'] as Carte;
            final client = extras['client'] as Client?;
            return ModifierPlafondPage(carte: carte, client: client);
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte/modifier-paimement-en-ligne',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;

            final carte = extras['carte'] as Carte;
            return PaiementEnLignePage(carte: carte);
          },
        ),
        GoRoute(
          path:
              '/paiements/cartes/details-carte/modifier-paimement-sans-contact',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final carte = extras['carte'] as Carte;
            return PaiementSansContactPage(carte: carte);
          },
        ),
        GoRoute(
          path: '/verifier_code',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return CodeVerificationPage(
              client: extra['client'],
              titre: extra['titre'],
              messageConfirmation: extra['message'],
              onSuccess: extra['onSuccess'],
            );
          },
        ),
        GoRoute(
          path: '/confirmation',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            return ConfirmationPage(
              titre: extras['titre'],
              client: extras["client"],
              message: extras['message'],
              onFinish: extras['onFinish'],
              futurePush: extras["futurePush"],
            );
          },
        ),
        GoRoute(
          path: '/rib',
          builder: (context, state) {
            final client = state.extra as Client?;
            return RIBPage(client: client);
          },
        ),
        GoRoute(
          path: '/cheques',
          builder: (context, state) {
            return ChequesPage();
          },
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client?;

            return NoTransitionPage(
              key: state.pageKey,
              child: ContactPage(client: client),
            );
          },
        ),
        GoRoute(
          path: '/virements',
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client?;

            return NoTransitionPage(
              key: state.pageKey,
              child: VirementsPage(client: client),
            );
          },
        ),
        GoRoute(
          path: '/virements/nouveau-virement',
          pageBuilder: (context, state) {

            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client?;
            return NoTransitionPage(
              key: state.pageKey,
              child: NouveauVirementPage(client: client),
            );
          },
        ),
        GoRoute(
          path: "/virements/beneficiaires",
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client?;

            return AjouterBeneficiairePage(client:client);
          },
        ),
        GoRoute(
          path: '/profil',
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client?;

            return NoTransitionPage(
              key: state.pageKey,
              child: ProfilPage(client: client),
            );
          },
        ),
        GoRoute(
          path: '/notifications',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: NotificationsPage(),
            );
          },
        ),
        GoRoute(
          path: "/virements/historique",
          builder: (context, state) {

            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client?;

            return HistoriqueVirementsPage(client: client);
          },
        ),
        GoRoute(
          path: "/detailsCompte",
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client?;

            return TransactionsCartePage(client: client);
          },
        ),
        GoRoute(
          path: "/modifier-email",
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client;

            return ChangerEmailPage(client: client, emailActuel:client.email ,);
          },
        ),
        GoRoute(
          path: "/modifier-tel",
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client;

            return ChangerTelephonePage(client: client, numeroActuel:client.numeroDeTelephone);
          },
        ),
        GoRoute(
          path: '/prets',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client?;
            return PretsPage(client: client);
          },
        ),
        GoRoute(
          path: '/prets/simulation',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client?;
            return SimulationPretPage(client: client);
          },
        ),
        GoRoute(
          path: "/modifier-mdp",
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final client = extras['client'] as Client;

            return ChangerMotDePassePage(client: client);
          },
        ),


      ],
    );
  }
}
