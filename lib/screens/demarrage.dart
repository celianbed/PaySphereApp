import 'package:flutter/material.dart';
import 'package:pay_sphere_app/services/storage.dart';
import 'login.dart';

class DemarragePage extends StatefulWidget {
  const DemarragePage({super.key});

  @override
  _DemarragePageState createState() => _DemarragePageState();
}

class _DemarragePageState extends State<DemarragePage> {

  @override
  void initState() {
    super.initState();
    _loadClientName();
  }

  String clientName = "";// Nom du client
  bool isLoggedIn = false;// Simule l'état de connexion;
  int currentPage = 0;// Page actuelle du PageView

  void _loadClientName() async {
    String? isLogin = await StorageService.getIsLogin();

    if (isLogin == "true") {
      String? name = await StorageService.getClientNom();
      setState(() {
        clientName = "M. $name";
        isLoggedIn = true;
      });
    }
  }

// Nom du client

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        children: [
          // Écran principal
          Stack(
            fit: StackFit.expand,
            children: [
              // Image de fond
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'lib/assets/images/first.jpg'
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Overlay sombre
              Container(
                color: Colors.black.withValues(alpha: 0.7),
              ),
              // Contenu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(), // Espace pour centrer

                    // Titre ou Nom du client
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLoggedIn ? clientName : 'PAY SPHERE',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isLoggedIn ? 'Balayer l\'écran vers la gauche pour afficher votre solde et vos dernières opérations.' :'Votre argent, sans frontières',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    // Boutons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.blue.shade900,
                            ),
                            onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, secondaryAnimation) => const Login(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeIn;
                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                      var offsetAnimation = animation.drive(tween);
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                            child: Text(
                              isLoggedIn ? 'Voir mes comptes' : 'Accéder à mes comptes',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Bouton "Envoyer de l'argent avec PayPal" ou "Devenir Client"
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.white, width: 2),
                              ),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {},
                            child: Text(
                              isLoggedIn ? 'Envoyer de l\'argent avec PayPal' : 'Devenir Client',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 1),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.white, width: 1.0),
                              ),
                            ),
                            child: const Text(
                              "Aide et services",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Page des opérations récentes et du solde
          Container(
            color: Colors.black.withValues(alpha: 0.9),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Mes Récentes Opérations",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Liste des transactions fictives
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(
                        title: Text("Achat chez Amazon", style: TextStyle(color: Colors.white)),
                        subtitle: Text("- 49.99€", style: TextStyle(color: Colors.redAccent)),
                      ),
                      ListTile(
                        title: Text("Virement reçu", style: TextStyle(color: Colors.white)),
                        subtitle: Text("+ 150.00€", style: TextStyle(color: Colors.greenAccent)),
                      ),
                      ListTile(
                        title: Text("Paiement Netflix", style: TextStyle(color: Colors.white)),
                        subtitle: Text("- 13.99€", style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                ),

                // Affichage du solde
                const Divider(color: Colors.white54),
                const SizedBox(height: 10),
                const Text(
                  "Solde disponible : 1,250.75€",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
