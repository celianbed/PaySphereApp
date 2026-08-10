import 'package:flutter_test/flutter_test.dart';
import 'package:pay_sphere_app/api/api_client.dart';

/// Ces tests encadrent la panne survenue en démonstration : l'instance
/// d'hébergement était en veille, son réveil a demandé plus d'une minute, et
/// le délai d'attente codé en dur à dix secondes garantissait l'échec de la
/// première connexion.
///
/// Mesure de référence relevée sur l'instance de production :
/// première requête après mise en veille, 61,6 s ; requêtes suivantes, 0,36 s.
const Duration reveilObserve = Duration(milliseconds: 61600);

void main() {
  group('Délais d\'attente', () {
    test('le délai de réveil couvre le démarrage à froid observé', () {
      expect(
        ApiClient.delaiReveil,
        greaterThan(reveilObserve),
        reason: 'Un délai inférieur au temps de réveil de l\'hébergeur rend la '
            'première connexion systématiquement impossible.',
      );
    });

    test('le délai de réveil garde une marge d\'au moins 30 %', () {
      // Le temps de réveil varie selon la charge de l'hébergeur : une marge
      // trop faible ramènerait la panne de façon intermittente.
      final margeMinimale = reveilObserve * 1.3;

      expect(ApiClient.delaiReveil, greaterThanOrEqualTo(margeMinimale));
    });

    test('le délai standard reste court une fois l\'instance réveillée', () {
      // Sur une instance chaude, une requête aboutit en moins d'une seconde :
      // conserver 90 s ferait patienter inutilement en cas de coupure réseau.
      expect(ApiClient.delaiStandard, lessThan(const Duration(seconds: 30)));
      expect(ApiClient.delaiStandard, greaterThanOrEqualTo(const Duration(seconds: 10)));
    });

    test('le délai de réveil est plus large que le délai standard', () {
      expect(ApiClient.delaiReveil, greaterThan(ApiClient.delaiStandard));
    });
  });

  group('État du serveur', () {
    test('l\'instance est considérée endormie au lancement', () {
      // Tant qu'aucune réponse n'a été reçue, c'est le délai large qui doit
      // s'appliquer.
      expect(ApiClient.serveurEveille, isFalse);
    });
  });
}
