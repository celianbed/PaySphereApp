import 'package:flutter/material.dart';
import '../models/client_model.dart';
import 'custom_app_bar.dart';
import 'navigation_wrapper.dart';

class AccueilPage extends StatefulWidget {
  final Client? client;

  const AccueilPage({super.key, required this.client});

  @override
  State<AccueilPage> createState() => _AccueilPage();
}

class _AccueilPage extends State<AccueilPage> {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final spacing = isTablet ? 16.0 : 30.0;

    return NavigationWrapper(
      currentIndex: 0,
      client: widget.client,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          title: "Accueil",
          showNotifications: true,
          client: widget.client,
        ),
        body: SafeArea(
      child: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.client != null)
            Text(
              "Bienvenue, ${widget.client!.prenom} 👋",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 20),
          _buildResumeCard(),
          const SizedBox(height: 20),
          _sectionTitle("Actions rapides"),
          const SizedBox(height: 10),
          _buildQuickActions(),
          const SizedBox(height: 30),
          _sectionTitle("Comptes, Assurances"),
          const SizedBox(height: 10),
          _buildAccountList(),
          const SizedBox(height: 30),
          _sectionTitle("Sélectionnés pour vous"),
          const SizedBox(height: 10),
          buildRecommendations(),
          const SizedBox(height: 30),
          _sectionTitle("Mes Extras"),
          const SizedBox(height: 10),
          _buildExtrasCard(),
          const SizedBox(height: 20), // ← évite l’overflow sur le bas
        ],
      ),
    ),
    ),

    ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87));
  }

  Widget _buildResumeCard() {
    final totalSolde = widget.client?.comptes.fold(0.0, (sum, compte) => sum + compte.solde) ?? 0.0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Solde total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Text("${totalSolde.toStringAsFixed(2)} €", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        _quickAction(Icons.send, "Virement", () {}),
        _quickAction(Icons.qr_code, "Scanner", () {}),
        _quickAction(Icons.account_balance, "RIB", () {}),
      ],
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: 28,
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAccountList() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.client?.comptes.map((compte) {
          return _buildAccountCard(
            compte.typeCompteNom,
            "${compte.solde.toStringAsFixed(2)} €",
            "À venir : 0.00 €",
          );
        }).toList() ?? [],
      ),
    );
  }

  Widget _buildAccountCard(String title, String balance, String upcoming) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text("04/03/2025", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          Text(balance, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(upcoming, style: const TextStyle(color: Colors.black54, fontSize: 16)),
        ],
      ),
    );
  }

  Widget buildRecommendations() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600; // seuil à adapter si besoin

        if (isTablet) {
          // Tablette : plusieurs colonnes
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3.5, // largeur / hauteur des cartes
            children: _recommendationCards(),
          );
        } else {
          // Smartphone : scroll horizontal
          return SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recommendationCards().length,
              itemBuilder: (context, index) => _recommendationCards()[index],
              separatorBuilder: (context, index) => const SizedBox(width: 16),
            ),
          );
        }
      },
    );
  }

  List<Widget> _recommendationCards() {
    return [
      _buildRecommendationCard(
        Icons.local_offer,
        Colors.blue,
        "Envie d’économiser ?",
        "Profitez de Mes Extras, notre programme de cashback !",
      ),
      _buildRecommendationCard(
        Icons.attach_money,
        Colors.green,
        "Besoin de trésorerie ?",
        "Souscrivez au mini-prêt FLOA !",
      ),
      _buildRecommendationCard(
        Icons.credit_card,
        Colors.green.shade700,
        "Assistance Carte Visa Classic",
        "Bénéficiez d’une assistance voyage 24h/24 et 7j/7.",
      ),
    ];
  }


  Widget _buildRecommendationCard(IconData icon, Color iconColor, String title, String description) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.blue.shade50]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 50),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: Colors.black54, fontSize: 14), maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtrasCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.blue.shade50]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month, color: Colors.blue.shade500, size: 60),
          const SizedBox(width: 20),
          const Text("Mars 2025", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
