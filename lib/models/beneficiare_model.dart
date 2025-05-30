
class Beneficiaire {

  final String nom;
  final String iban;
  final int clientId;
  final int? id; // nullable

  Beneficiaire({
  required this.nom,
  required this.iban,
  required this.clientId,
  this.id, // optionnel
  });

  factory Beneficiaire.fromJson(Map<String, dynamic> json) {
    return Beneficiaire(
      id: json['id'],
      nom: json['nom'],
      iban: json['iban'],
      clientId: json['client_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'iban': iban,
      'client_id': clientId,
    };
  }

}
