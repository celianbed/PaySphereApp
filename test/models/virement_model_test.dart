import 'package:flutter_test/flutter_test.dart';
import 'package:pay_sphere_app/models/virement_model.dart';

Map<String, dynamic> _virementJson({dynamic montant = '1500.00'}) {
  return {
    'id': 12,
    'compte_source_nom': 'M. Dupont Jean',
    'compte_destination_nom': 'Mme Martin Sophie',
    'montant': montant,
    'date_virement': 'Mon, 10 Aug 2026 00:00:00 GMT',
    'statut_nom': 'Terminé',
    'type_virement_nom': 'Instantané',
  };
}

void main() {
  group('Virement.fromJson', () {
    test('décode le format actuel de l\'API, où le montant est une chaîne', () {
      final virement = Virement.fromJson(_virementJson());

      expect(virement.id, 12);
      expect(virement.montant, 1500.00);
      expect(virement.compteSourceNom, 'M. Dupont Jean');
    });

    test('accepte un montant transmis comme nombre', () {
      // Un changement de type de colonne côté API suffirait à produire ce cas.
      expect(Virement.fromJson(_virementJson(montant: 1500)).montant, 1500.00);
      expect(Virement.fromJson(_virementJson(montant: 1500.5)).montant, 1500.50);
    });

    test('ne lève pas d\'exception sur un montant illisible', () {
      // Mieux vaut afficher zéro qu'un écran blanc : l'utilisateur voit
      // l'historique, et l'anomalie reste visible.
      expect(() => Virement.fromJson(_virementJson(montant: 'inconnu')),
          returnsNormally);
      expect(Virement.fromJson(_virementJson(montant: 'inconnu')).montant, 0.0);
    });

    test('ne lève pas d\'exception sur un montant absent', () {
      expect(() => Virement.fromJson(_virementJson(montant: null)),
          returnsNormally);
    });
  });

  group('Virement.toJson', () {
    test('un aller-retour préserve le montant', () {
      final origine = Virement.fromJson(_virementJson());
      final apresAllerRetour = Virement.fromJson(origine.toJson());

      expect(apresAllerRetour.montant, origine.montant);
      expect(apresAllerRetour.id, origine.id);
    });
  });
}
