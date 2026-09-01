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
import 'extras.dart';
import 'transitions.dart';
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
  static GoRouter routerConfiguration({
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return GoRouter(
      navigatorKey: navigatorKey,
      routes: <RouteBase>[
        GoRoute(
          path: '/demarrage',
          pageBuilder: (context, state) {
            Client? client = state.extra as Client?;
            return pageGlissee(
              key: state.pageKey,
              child: DemarragePage(client: client),
            );
          },
        ),

        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            Client? client = state.extra as Client?;

            return pageGlissee(
              key: state.pageKey,
              child: LoginPage(clientInitial: client),
            );
          },
        ),
        GoRoute(
          path: '/accueil',
          pageBuilder: (context, state) {
            final client = lireClient(state);
            return pageFondu(
              key: state.pageKey,
              child: ClientRestaure(
                client: client,
                construire: (client) => AccueilPage(client: client),
              ),
            );
          },
        ),

        GoRoute(
          path: "/register",
          pageBuilder: (context, state) {
            return pageGlissee(key: state.pageKey, child: RegisterPage());
          },
        ),
        GoRoute(
          path: '/paiements',
          pageBuilder: (context, state) {
            final client = lireClient(state);
            return pageFondu(
              key: state.pageKey,
              child: ClientRestaure(
                client: client,
                construire: (client) => PaiementsPage(client: client),
              ),
            );
          },
        ),
        GoRoute(
          path: '/paiements/cartes',
          pageBuilder: (context, state) {
            final client = lireClient(state);

            return pageGlissee(
              key: state.pageKey,
              child: ClientRestaure(
                client: client,
                construire: (client) => CartesPage(client: client),
              ),
            );
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte',
          // Une carte ne peut pas être restaurée depuis l'URL : après un
          // rechargement, on renvoie vers la liste des cartes.
          redirect:
              (context, state) =>
                  lireExtras(state)['carte'] is Carte
                      ? null
                      : '/paiements/cartes',
          builder: (context, state) {
            final extras = lireExtras(state);
            final carte = extras['carte'] as Carte;
            final client = lireClient(state);
            return CarteDetailPage(carte: carte, client: client);
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte/opposition',
          // Une carte ne peut pas être restaurée depuis l'URL : après un
          // rechargement, on renvoie vers la liste des cartes.
          redirect:
              (context, state) =>
                  lireExtras(state)['carte'] is Carte
                      ? null
                      : '/paiements/cartes',
          builder: (context, state) {
            final extras = lireExtras(state);
            final carte = extras['carte'] as Carte;
            final client = lireClient(state);

            return ClientRestaure(
              client: client,
              construire:
                  (client) => OppositionPage(carte: carte, client: client),
            );
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte/plafonds',
          // Une carte ne peut pas être restaurée depuis l'URL : après un
          // rechargement, on renvoie vers la liste des cartes.
          redirect:
              (context, state) =>
                  lireExtras(state)['carte'] is Carte
                      ? null
                      : '/paiements/cartes',
          builder: (context, state) {
            final extras = lireExtras(state);
            final carte = extras['carte'] as Carte;
            final client = lireClient(state);

            return CartePlafondPage(carte: carte, client: client);
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte/plafonds/modifier-plafond',
          // Une carte ne peut pas être restaurée depuis l'URL : après un
          // rechargement, on renvoie vers la liste des cartes.
          redirect:
              (context, state) =>
                  lireExtras(state)['carte'] is Carte
                      ? null
                      : '/paiements/cartes',
          builder: (context, state) {
            final extras = lireExtras(state);
            final carte = extras['carte'] as Carte;
            final client = lireClient(state);
            return ModifierPlafondPage(carte: carte, client: client);
          },
        ),
        GoRoute(
          path: '/paiements/cartes/details-carte/modifier-paimement-en-ligne',
          // Une carte ne peut pas être restaurée depuis l'URL : après un
          // rechargement, on renvoie vers la liste des cartes.
          redirect:
              (context, state) =>
                  lireExtras(state)['carte'] is Carte
                      ? null
                      : '/paiements/cartes',
          builder: (context, state) {
            final extras = lireExtras(state);

            final carte = extras['carte'] as Carte;
            return PaiementEnLignePage(carte: carte);
          },
        ),
        GoRoute(
          path:
              '/paiements/cartes/details-carte/modifier-paimement-sans-contact',
          // Une carte ne peut pas être restaurée depuis l'URL : après un
          // rechargement, on renvoie vers la liste des cartes.
          redirect:
              (context, state) =>
                  lireExtras(state)['carte'] is Carte
                      ? null
                      : '/paiements/cartes',
          builder: (context, state) {
            final extras = lireExtras(state);
            final carte = extras['carte'] as Carte;
            return PaiementSansContactPage(carte: carte);
          },
        ),
        GoRoute(
          path: '/verifier_code',
          // Cet écran s'appuie sur des fonctions de rappel, qui ne
          // survivent pas à un rechargement.
          redirect:
              (context, state) =>
                  state.extra is Map<String, dynamic> ? null : '/accueil',
          builder: (context, state) {
            final extra = lireExtras(state);
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
          // Cet écran s'appuie sur des fonctions de rappel, qui ne
          // survivent pas à un rechargement.
          redirect:
              (context, state) =>
                  state.extra is Map<String, dynamic> ? null : '/accueil',
          builder: (context, state) {
            final extras = lireExtras(state);
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
            final client = lireClient(state);
            return ClientRestaure(
              client: client,
              construire: (client) => RIBPage(client: client),
            );
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
            final client = lireClient(state);

            return pageFondu(
              key: state.pageKey,
              child: ClientRestaure(
                client: client,
                construire: (client) => ContactPage(client: client),
              ),
            );
          },
        ),
        GoRoute(
          path: '/virements',
          pageBuilder: (context, state) {
            final client = lireClient(state);

            return pageGlissee(
              key: state.pageKey,
              child: ClientRestaure(
                client: client,
                construire: (client) => VirementsPage(client: client),
              ),
            );
          },
        ),
        GoRoute(
          path: '/virements/nouveau-virement',
          pageBuilder: (context, state) {
            final client = lireClient(state);
            return pageGlissee(
              key: state.pageKey,
              child: ClientRestaure(
                client: client,
                construire: (client) => NouveauVirementPage(client: client),
              ),
            );
          },
        ),
        GoRoute(
          path: "/virements/beneficiaires",
          builder: (context, state) {
            final client = lireClient(state);

            return ClientRestaure(
              client: client,
              construire: (client) => AjouterBeneficiairePage(client: client),
            );
          },
        ),
        GoRoute(
          path: '/profil',
          pageBuilder: (context, state) {
            final client = lireClient(state);

            return pageFondu(
              key: state.pageKey,
              child: ClientRestaure(
                client: client,
                construire: (client) => ProfilPage(client: client),
              ),
            );
          },
        ),
        GoRoute(
          path: '/notifications',
          pageBuilder: (context, state) {
            return pageGlissee(key: state.pageKey, child: NotificationsPage());
          },
        ),
        GoRoute(
          path: "/virements/historique",
          builder: (context, state) {
            final client = lireClient(state);

            return ClientRestaure(
              client: client,
              construire: (client) => HistoriqueVirementsPage(client: client),
            );
          },
        ),
        GoRoute(
          path: "/detailsCompte",
          builder: (context, state) {
            final client = lireClient(state);

            return ClientRestaure(
              client: client,
              construire: (client) => TransactionsCartePage(client: client),
            );
          },
        ),
        GoRoute(
          path: "/modifier-email",
          builder: (context, state) {
            final client = lireClient(state);

            return ClientRestaure(
              client: client,
              construire:
                  (client) => ChangerEmailPage(
                    client: client,
                    emailActuel: client.email,
                  ),
            );
          },
        ),
        GoRoute(
          path: "/modifier-tel",
          builder: (context, state) {
            final client = lireClient(state);

            return ClientRestaure(
              client: client,
              construire:
                  (client) => ChangerTelephonePage(
                    client: client,
                    numeroActuel: client.numeroDeTelephone,
                  ),
            );
          },
        ),
        GoRoute(
          path: '/prets',
          builder: (context, state) {
            final client = lireClient(state);
            return ClientRestaure(
              client: client,
              construire: (client) => PretsPage(client: client),
            );
          },
        ),
        GoRoute(
          path: '/prets/simulation',
          builder: (context, state) {
            final client = lireClient(state);
            return ClientRestaure(
              client: client,
              construire: (client) => SimulationPretPage(client: client),
            );
          },
        ),
        GoRoute(
          path: "/modifier-mdp",
          builder: (context, state) {
            final client = lireClient(state);

            return ClientRestaure(
              client: client,
              construire: (client) => ChangerMotDePassePage(client: client),
            );
          },
        ),
      ],
    );
  }
}
