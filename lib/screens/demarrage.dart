import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/providers/client_provider.dart';

import '../models/client_model.dart';

class DemarragePage extends StatefulWidget {

  final Client? client;

  const DemarragePage({
    super.key,
    required this.client,
  });

  @override
  State<DemarragePage> createState() => _DemarragePageState();
}


class _DemarragePageState extends State<DemarragePage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fond d'écran
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/first.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.7)),

          // Contenu principal
          Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: [
                    _buildMainPageContent(),
                    if (widget.client != null) _buildTransactionsContent(),
                  ],
                ),
              ),
              // Indicateurs de page
              if (widget.client != null) Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPage == index ? Colors.white : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),

              // Boutons fixes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _buildButtons(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainPageContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.client != null ? "M. ${widget.client?.nom}" : 'PAY SPHERE',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            widget.client != null
                ? 'Balayer l\'écran pour voir vos opérations.'
                : 'Votre argent, sans frontières',
            style: const TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mes Récentes Opérations",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  title: Text("Intérêts minimum forfaitaire", style: TextStyle(color: Colors.white)),
                  subtitle: Text("- 7,00 €", style: TextStyle(color: Colors.redAccent)),
                ),
                ListTile(
                  title: Text("Cotisation commission", style: TextStyle(color: Colors.white)),
                  subtitle: Text("- 2,96 €", style: TextStyle(color: Colors.redAccent)),
                ),
                ListTile(
                  title: Text("Forfait option", style: TextStyle(color: Colors.white)),
                  subtitle: Text("- 5,00 €", style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white54),
          const SizedBox(height: 10),
           Text(
            "Solde disponible : ${widget.client?.getComptes()[0].solde.toStringAsFixed(2)} €",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.blue.shade900,
            ),
            onPressed: () {
              context.push('/login', extra: widget.client);
            },
            child: const Text("Accéder à mes comptes", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 10),
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
            onPressed: () {

              if (widget.client == null) {
                context.push('/register');
              }

            },
            child: Text(widget.client != null ? "Envoyer de l'argent avec WERO" : "Devenir client PaySphere", style: const TextStyle(fontSize: 18))
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {},
          child: const Text("Aide et services", style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ],
    );
  }
}
