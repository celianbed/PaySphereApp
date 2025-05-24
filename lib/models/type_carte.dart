class TypeCarte {
  final int id;
  final String nom;

  TypeCarte({
    required this.id,
    required this.nom,
  });

  factory TypeCarte.fromJson(Map<String, dynamic> json) {
    return TypeCarte(
      id: json['id'],
      nom: json['nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }
}
