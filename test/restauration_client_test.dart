import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_sphere_app/models/client_model.dart';
import 'package:pay_sphere_app/utils/extras.dart';

/// Quand la navigation transmet déjà le client, la page doit se construire
/// dans la même frame.
///
/// Un `FutureBuilder` démarre toujours en `ConnectionState.waiting`, même sur
/// un futur déjà résolu : la page affichait donc un indicateur de chargement
/// plein écran pendant une frame à chaque changement d'écran, ce qui se voyait
/// comme un clignotement blanc et écrasait les transitions.
void main() {
  final client = Client(
    id: 1,
    nom: 'Rousseau',
    prenom: 'Camille',
    numClient: 200001,
    email: 'camille.rousseau@email.com',
    adresse: '24 Rue des Lilas, 69003 Lyon',
    numeroDeTelephone: '0611223344',
    dateNaissance: DateTime(1992, 3, 8),
    comptes: const [],
    beneficiaires: const [],
  );

  testWidgets('la page s\'affiche dès la première frame, sans indicateur', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ClientRestaure(
          client: client,
          construire: (client) => Text('Bonjour ${client.prenom}'),
        ),
      ),
    );

    // Volontairement aucun `pumpAndSettle` : on observe la toute première
    // frame, celle où le clignotement se produisait.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Bonjour Camille'), findsOneWidget);
  });
}
