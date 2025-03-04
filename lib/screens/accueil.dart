import 'package:flutter/material.dart';



class AccueilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        title: Text("Accueil", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.notifications, color: Colors.white), onPressed: () {}),
          IconButton(icon: Icon(Icons.power_settings_new, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comptes et assurances
            Text("Comptes, assurances", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildAccountCard("Compte de chèques", "118,06 €", "-88,78 €")),
                SizedBox(width: 10),
                Expanded(child: _buildAccountCard("Livret A", "00 €", "0,00 €")),
              ],
            ),
            SizedBox(height: 20),
            // Section recommandée
            Text("Sélectionnés pour vous", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            _buildRecommendationCard(),
            SizedBox(height: 20),
            // Mes Extras
            Text("Mes Extras", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            _buildExtrasCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Paiements"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Découvrir"),
          BottomNavigationBarItem(icon: Icon(Icons.contact_support), label: "Contact"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Vous"),
        ],
      ),
    );
  }

  Widget _buildAccountCard(String title, String balance, String upcoming) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("04/03/2025", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10),
          Text(balance, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("À venir : $upcoming", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: Colors.blue[700], size: 40),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Envie d’économiser ?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 5),
                Text("Profitez de Mes Extras, notre programme de cashback !", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.close, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildExtrasCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month, color: Colors.blue[700], size: 40),
          SizedBox(width: 10),
          Text("Mars 2025", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
