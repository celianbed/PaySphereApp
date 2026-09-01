import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/client_model.dart';
import '../services/storage.dart';

/// Lecture défensive de `GoRouterState.extra`.
///
/// `extra` n'est pas porté par l'URL : il disparaît dès qu'une route est
/// reconstruite sans passer par une navigation applicative — redémarrage à
/// chaud, retour depuis l'arrière-plan, rafraîchissement sur le web. Un
/// `state.extra as Map<String, dynamic>` lève alors une erreur de type qui
/// remonte jusqu'à l'interface. L'absence d'`extra` est un cas nominal.
Map<String, dynamic> lireExtras(GoRouterState state) {
  final extra = state.extra;
  return extra is Map<String, dynamic> ? extra : const <String, dynamic>{};
}

/// Client transmis par la navigation, `null` après un rechargement.
///
/// Quelques routes transmettent le client seul plutôt que dans une map ; les
/// deux formes sont acceptées.
Client? lireClient(GoRouterState state) {
  final extra = state.extra;
  if (extra is Client) return extra;
  final valeur = lireExtras(state)['client'];
  return valeur is Client ? valeur : null;
}

/// Fournit un client aux écrans qui en dépendent, y compris lorsque le
/// rechargement d'une page a fait disparaître `extra`.
///
/// Le client est alors relu depuis le stockage sécurisé, où la connexion l'a
/// enregistré. S'il n'y figure pas non plus, la session est réellement absente
/// et l'utilisateur est renvoyé vers l'écran de connexion — plutôt que de
/// construire un écran dont chaque `client!` lèverait une exception.
class ClientRestaure extends StatefulWidget {
  const ClientRestaure({
    super.key,
    required this.client,
    required this.construire,
  });

  final Client? client;
  final Widget Function(Client client) construire;

  @override
  State<ClientRestaure> createState() => _ClientRestaureState();
}

class _ClientRestaureState extends State<ClientRestaure> {
  late final Future<Client?> _client;

  @override
  void initState() {
    super.initState();
    // Le client déjà transmis est conservé tel quel : le stockage n'est
    // interrogé que dans le cas d'un rechargement.
    _client =
        widget.client != null
            ? Future<Client?>.value(widget.client)
            : StorageService.getClient();
  }

  @override
  Widget build(BuildContext context) {
    // Le client transmis par la navigation est disponible immédiatement : il
    // faut construire la page dans la même frame. `FutureBuilder` démarre
    // toujours en `waiting`, même sur un futur déjà résolu, et ferait donc
    // clignoter un indicateur de chargement à chaque changement de page.
    final dejaLa = widget.client;
    if (dejaLa != null) return widget.construire(dejaLa);

    return FutureBuilder<Client?>(
      future: _client,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _AttenteRestauration();
        }

        final client = snapshot.data;
        if (client == null) {
          // La redirection ne peut pas avoir lieu pendant la construction.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/login');
          });
          return const _AttenteRestauration();
        }

        return widget.construire(client);
      },
    );
  }
}

class _AttenteRestauration extends StatelessWidget {
  const _AttenteRestauration();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
