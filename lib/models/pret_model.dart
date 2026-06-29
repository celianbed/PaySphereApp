class Pret {
  final int id;
  final int clientId;
  final double montantPret;
  final double tauxInteret;
  final DateTime dateDemande;
  final DateTime dateEcheance;
  final String statut;

  Pret({
    required this.id,
    required this.clientId,
    required this.montantPret,
    required this.tauxInteret,
    required this.dateDemande,
    required this.dateEcheance,
    required this.statut,
  });

  factory Pret.fromJson(Map<String, dynamic> json) {
    return Pret(
      id: json['id'],
      clientId: json['client_id'],
      montantPret: (json['montant_pret'] as num).toDouble(),
      tauxInteret: (json['taux_interet'] as num).toDouble(),
      dateDemande: DateTime.parse(json['date_demande']),
      dateEcheance: DateTime.parse(json['date_echeance']),
      statut: json['statut'] ?? 'inconnu',
    );
  }

  String get statutLabel {
    switch (statut) {
      case 'en_attente':
        return 'En attente';
      case 'approuve':
        return 'Approuvé';
      case 'refuse':
        return 'Refusé';
      case 'annule':
        return 'Annulé';
      default:
        return statut;
    }
  }
}
