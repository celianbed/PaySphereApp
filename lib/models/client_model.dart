import 'beneficiare_model.dart';
import 'compte_model.dart';

class Client {
  final int id;
  final int? userId;
  final String nom;
  final String prenom;
  final int? numClient;
  late String email;
  final String adresse;
  late  String numeroDeTelephone;
  final DateTime dateNaissance;
  final List<Compte> comptes;
  late  List<Beneficiaire> beneficiaires;

  Client({
    required this.id,
    this.userId,
    required this.nom,
    required this.prenom,
    this.numClient,
    required this.email,
    required this.adresse,
    required this.numeroDeTelephone,
    required this.dateNaissance,
    required this.comptes,
    required this.beneficiaires
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: int.parse(json['client_id'].toString()),
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      nom: json['nom'],
      prenom: json['prenom'],
      numClient: json['num_client'] != null ? int.tryParse(json['num_client'].toString()) : null,
      email: json['email'],
      adresse: json['adresse'],
      numeroDeTelephone: json['numero_de_telephone'],
      dateNaissance: DateTime.parse(json['date_naissance']),
      comptes: (json['comptes'] as List)
        .map((item) => Compte.fromJson(item))
        .toList(),
      beneficiaires: (json['beneficiaires'] as List)
        .map((item) => Beneficiaire.fromJson(item))
        .toList());
  }
  Map<String, dynamic> toJson() {
    return {
      'client_id': id,
      'user_id': userId,
      'nom': nom,
      'prenom': prenom,
      'num_client': numClient,
      'email': email,
      'adresse': adresse,
      'numero_de_telephone': numeroDeTelephone,
      'date_naissance': dateNaissance.toIso8601String(),
      'comptes': comptes.map((compte) => compte.toJson()).toList(),
      'beneficiaires': beneficiaires.map((beneficiaire) => beneficiaire.toJson()).toList(),
    };
  }



  List<Compte> getComptes() {
    return comptes;
  }

  String getNom(){
    return nom;
  }

}
