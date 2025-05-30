import 'package:pay_sphere_app/models/rib_model.dart';
import 'package:pay_sphere_app/models/virement_model.dart';
import 'carte_model.dart';

class Compte {
  int id;
  int clientId;
  String typeCompteNom;
  String statutNom;
  int numeroCompte;
  double solde;
  DateTime dateOuverture;
  Rib? rib;
  List<Virement> virementEnvoye;
  List<Virement> virementRecu;
  List<Carte> cartes;

  Compte({
    required this.id,
    required this.clientId,
    required this.typeCompteNom,
    required this.statutNom,
    required this.numeroCompte,
    this.solde = 0.0,
    required this.dateOuverture,
    this.rib,
    required this.virementEnvoye,
    required this.virementRecu,
    required this.cartes
  });

  /// Créer un `Compte` depuis un `Map<String, dynamic>`
  factory Compte.fromJson(Map<String, dynamic> json) {
    return Compte(
      id: json["id"],
      clientId: json["client_id"],
      typeCompteNom: json["type_compte_nom"],
      numeroCompte: json["numero_compte"],
      statutNom: json["statut_nom"],
      solde: (json["solde"] as num).toDouble(),
      dateOuverture: DateTime.parse(json["date_ouverture"]),
      rib: Rib.fromJson(json["rib"]),
      virementEnvoye: (json['virements_envoye'] as List)
          .map((item) => Virement.fromJson(item))
          .toList(),
      virementRecu: (json['virements_recu'] as List)
          .map((item) => Virement.fromJson(item))
          .toList(),
      cartes: (json['cartes'] as List)
          .map((item) => Carte.fromJson(item))
          .toList(),
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'type_compte_nom': typeCompteNom,
      'numero_compte': numeroCompte,
      'statut_nom': statutNom,
      'solde': solde,
      'date_ouverture': dateOuverture.toIso8601String(),
      'rib': rib?.toJson(),
      'virements_envoye': virementEnvoye.map((v) => v.toJson()).toList(),
      'virements_recu': virementRecu.map((v) => v.toJson()).toList(),
      'cartes': cartes.map((c) => c.toJson()).toList() // Ajoutez ici la logique pour les cartes si nécessair
    };
  }
}
