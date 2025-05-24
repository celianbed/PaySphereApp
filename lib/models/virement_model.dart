class Virement{

  int id;
  String compteSourceNom;
  String compteDestinataireNom;
  double montant;
  String date;
  String statutNom;
  String typeVirementNom;

  Virement({
    required this.id,
    required this.compteSourceNom,
    required this.compteDestinataireNom,
    required this.montant,
    required this.date,
    required this.statutNom,
    required this.typeVirementNom,
  });

  factory Virement.fromJson(Map<String, dynamic> json) {
    return Virement(
      id: json["id"],
      compteSourceNom: json["compte_source_nom"],
      compteDestinataireNom: json["compte_destination_nom"],
      montant: (num.tryParse(json["montant"]))!.toDouble(),
      date: json["date_virement"],
      statutNom: json["statut_nom"],
      typeVirementNom: json["type_virement_nom"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'compte_source_nom': compteSourceNom,
      'compte_destination_nom': compteDestinataireNom,
      'montant': montant.toStringAsFixed(2), // ou juste `montant` si tu préfères un double
      'date_virement': date,
      'statut_nom': statutNom,
      'type_virement_nom': typeVirementNom,
    };
  }
}