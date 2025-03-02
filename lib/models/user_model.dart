class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String username;
  final String dateCreation;
  final String? miseAJour;
  final bool active;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.username,
    required this.dateCreation,
    this.miseAJour,
    required this.active,
  });

  // Convertir un JSON en objet User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      username: json['username'],
      dateCreation: json['date_creation'],
      miseAJour: json['mise_a_jour'],
      active: json['active'],
    );
  }

  // Convertir un objet User en JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "username": username,
      "date_creation": dateCreation,
      "mise_a_jour": miseAJour,
      "active": active,
    };
  }
}
