
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/providers/auth_providers.dart';
import 'package:pay_sphere_app/screens/accueil.dart';
import 'package:pay_sphere_app/screens/demarrage.dart';
import 'package:pay_sphere_app/screens/paiement/paiments.dart';
import 'package:pay_sphere_app/screens/register.dart';

import '../main.dart';
import '../models/client_model.dart';
import '../screens/login.dart';
import '../screens/paiement/carte/cartes.dart';

class Routes {

  static GoRouter routerConfiguration() {
    return GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/demarrage',
          pageBuilder: (context, state) {

            Client? client = state.extra as Client?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: DemarragePage(client: client),
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                final offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            );
          },
        ),

        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {

            Client? client = state.extra as Client?;

            return CustomTransitionPage(
              key: state.pageKey,
              child: LoginPage(client:client),
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut; // Animation plus fluide

                final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                final offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/accueil',
          pageBuilder: (context, state) {
            final client = state.extra as Client?;
            return NoTransitionPage(
              key: state.pageKey,
              child: AccueilPage(client: client),
            );
          },
        ),

        GoRoute(path: "/register", pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: RegisterPage(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        }),
        GoRoute(
          path: '/paiements',
          pageBuilder: (context, state) {
            final client = state.extra as Client?;
            return NoTransitionPage(
              key: state.pageKey,
              child: PaiementsPage(client: client),
            );
          },
        ),
        GoRoute(
          path: '/cartes',
          pageBuilder: (context, state) {
            final client = state.extra as Client?;
            return NoTransitionPage(
              key: state.pageKey,
              child: CartesPage(client: client),
            );
          },
        ),



      ],
    );
  }

}
