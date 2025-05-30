class Rib {

  int id;
  int compteId;
  String iban;
  String bic;
  String titulaire;
  String banque;
  String? agence;
  String? adresseBanque;


  Rib({
    required this.id,
    required this.compteId,
    required this.iban,
    required this.bic,
    required this.titulaire,
    required this.banque,
    required this.agence,
    required this.adresseBanque,
  });

  factory Rib.fromJson(Map<String, dynamic> json) {
    return Rib(
        id: json["id"],
        compteId: json["compte_id"],
        iban: json["iban"],
        bic: json["bic"],
        titulaire: json["titulaire_compte"],
        banque: json["banque"],
        agence: json["agence"],
        adresseBanque: json["adresse_banque"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'compte_id': compteId,
      'iban': iban,
      'bic': bic,
      'titulaire_compte': titulaire,
      'banque': banque,
      'agence': agence,
      'adresse_banque': adresseBanque,
    };
  }
}