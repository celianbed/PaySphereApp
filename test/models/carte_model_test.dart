import 'package:flutter_test/flutter_test.dart';
import 'package:pay_sphere_app/models/carte_model.dart';

/// Réponse représentative de `GET /comptes` pour une carte.
///
/// Le contrat est celui de `Carte.to_dict()` côté API : toute divergence entre
/// ce descripteur et la réponse réelle provoque une exception de type au
/// moment du décodage, donc un écran blanc en production.
Map<String, dynamic> _carteJson({Map<String, dynamic> surcharges = const {}}) {
  return {
    'id': 7,
    'numero_carte': '4970100012345678',
    'date_expiration': '2028-05-31',
    'type_carte': {'id': 1, 'nom': 'Visa Classic'},
    'numero_compte': 455378,
    'active': true,
    'plafond': 1500,
    'paiment_sans_contact': true,
    'paiment_en_ligne': false,
    ...surcharges,
  };
}

void main() {
  group('Carte.fromJson', () {
    test('décode une réponse complète de l\'API', () {
      final carte = Carte.fromJson(_carteJson());

      expect(carte.id, 7);
      expect(carte.numeroCarte, '4970100012345678');
      expect(carte.typeCarte.nom, 'Visa Classic');
      expect(carte.plafond, 1500);
      expect(carte.paimentSansContact, isTrue);
      expect(carte.paimentEnLigne, isFalse);
    });

    test('décode une réponse dépourvue de cryptogramme', () {
      // L'API ne renvoie plus `code_securite` : le décodage ne doit dépendre
      // d'aucune façon de ce champ.
      final json = _carteJson();
      expect(json.containsKey('code_securite'), isFalse);

      expect(() => Carte.fromJson(json), returnsNormally);
    });

    test('ignore un cryptogramme résiduel sans échouer', () {
      // Cas d'une API non encore mise à jour : le champ excédentaire ne doit
      // pas empêcher le décodage.
      final carte = Carte.fromJson(
        _carteJson(surcharges: {'code_securite': '123'}),
      );

      expect(carte.id, 7);
    });
  });

  group('Carte.toJson', () {
    test('ne sérialise jamais le cryptogramme', () {
      // Le modèle est écrit dans le stockage local : le cryptogramme ne doit
      // pas pouvoir y arriver par ce chemin non plus.
      final serialise = Carte.fromJson(_carteJson()).toJson();

      expect(serialise.containsKey('code_securite'), isFalse);
    });

    test('conserve les champs nécessaires à l\'affichage', () {
      final serialise = Carte.fromJson(_carteJson()).toJson();

      expect(serialise['numero_carte'], '4970100012345678');
      expect(serialise['plafond'], 1500);
      expect(serialise['active'], isTrue);
    });

    test('un aller-retour préserve les données', () {
      final origine = Carte.fromJson(_carteJson());
      final apresAllerRetour = Carte.fromJson(origine.toJson());

      expect(apresAllerRetour.id, origine.id);
      expect(apresAllerRetour.numeroCarte, origine.numeroCarte);
      expect(apresAllerRetour.typeCarte.nom, origine.typeCarte.nom);
      expect(apresAllerRetour.plafond, origine.plafond);
    });
  });
}
