import 'package:pay_sphere_app/models/type_carte.dart';

class Carte {
  final int id;
  final String numeroCarte;
  final String dateExpiration;
  final String codeSecurite;
  final TypeCarte typeCarte;
  final int numeroCompte;
  bool active;
  late int plafond;
  late  bool paimentSansContact;
  late  bool paimentEnLigne;


  Carte({
    required this.id,
    required this.numeroCarte,
    required this.dateExpiration,
    required this.codeSecurite,
    required this.typeCarte,
    required this.numeroCompte,
    required this.active,
    required this.plafond,
    required this.paimentSansContact,
    required this.paimentEnLigne,
  });

  factory Carte.fromJson(Map<String, dynamic> json) {
    return Carte(
      id: json['id'],
      numeroCarte: json['numero_carte'],
      dateExpiration: json['date_expiration'],
      codeSecurite: json['code_securite'],
      typeCarte: TypeCarte.fromJson(json['type_carte']),
      numeroCompte: json['numero_compte'],
      active: json['active'],
      plafond: json['plafond'],
      paimentSansContact: json['paiment_sans_contact'],
      paimentEnLigne: json['paiment_en_ligne'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_carte': numeroCarte,
      'date_expiration': dateExpiration,
      'code_securite': codeSecurite,
      'type_carte': typeCarte.toJson(),
      'numero_compte': numeroCompte,
      'active': active,
      'plafond': plafond,
      'paiment_sans_contact': paimentSansContact,
      'paiment_en_ligne': paimentEnLigne,
    };
  }

}
