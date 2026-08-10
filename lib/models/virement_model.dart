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

  /// Convertit un montant reçu de l'API en `double`.
  ///
  /// Le montant est sérialisé en chaîne par SQLAlchemy (`Numeric`), mais rien
  /// ne garantit ce format : un changement de type de colonne le ferait
  /// arriver sous forme de nombre. L'ancienne implémentation
  /// (`num.tryParse(json["montant"])!`) levait alors une exception de type,
  /// et une exception d'assertion sur une chaîne non numérique. Les deux cas
  /// se manifestaient par un écran blanc, sans message exploitable.
  static double _versDouble(dynamic valeur) {
    if (valeur is num) return valeur.toDouble();
    if (valeur is String) return double.tryParse(valeur) ?? 0.0;
    return 0.0;
  }

  factory Virement.fromJson(Map<String, dynamic> json) {
    return Virement(
      id: json["id"],
      compteSourceNom: json["compte_source_nom"],
      compteDestinataireNom: json["compte_destination_nom"],
      montant: _versDouble(json["montant"]),
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