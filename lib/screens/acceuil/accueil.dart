import 'dart:async'; // Pour les timers
import 'package:flutter/material.dart'; // Pour les widgets Flutter
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Pour les notifications locales
import 'package:go_router/go_router.dart'; // Pour la navigation avec GoRouter
import 'package:intl/intl.dart'; // Pour le formatage des dates
import 'package:pay_sphere_app/api/notification_api.dart'; // API perso pour gérer les notifications
import '../../models/client_model.dart'; // Modèle client
import '../../services/storage.dart'; // Pour la gestion du stockage local
import '../autres/custom_app_bar.dart'; // AppBar personnalisée
import '../autres/navigation_wrapper.dart'; // Wrapper pour navigation + bottom bar

// Instance globale pour afficher les notifications locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Timer? _notificationTimer; // Timer pour interroger les notifications
int? lastNotificationId; // Pour éviter de réafficher la même notif plusieurs fois

// Classe principale de la page d'accueil
class AccueilPage extends StatefulWidget {
  final Client? client; // Le client connecté
  final f = DateFormat('dd/MM/yyyy'); // Formateur de date

  AccueilPage({super.key, required this.client});

  @override
  State<AccueilPage> createState() => _AccueilPage();
}

class _AccueilPage extends State<AccueilPage> {
  @override
  void initState() {
    super.initState();
    startNotificationPolling(context); // Lance le polling des notifs toutes les 10 sec
  }

  void startNotificationPolling(BuildContext context) {
    // Timer toutes les 10 secondes pour vérifier les nouvelles notifs
    _notificationTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      checkNewNotifications(context);
    });
  }

  Future<void> checkNewNotifications(BuildContext context) async {
    // Récupère l'id du client
    final clientId = widget.client?.id;

    // Récupère toutes les notifications de l'API
    final notifs = await NotificationApi.fetchNotifications(context);

    // Filtre les notifications destinées au client courant
    final filtered = notifs.where((n) => n["client_id"] == clientId).toList();

    if (filtered.isNotEmpty) {
      final notif = filtered.first;

      // Si c'est une nouvelle notif, on l'affiche
      if (lastNotificationId != notif["id"]) {
        lastNotificationId = notif["id"];
        await showLocalNotification("Nouvelle notification", notif["message"], notif["id"]);
      }
    }
  }

  Future<void> showLocalNotification(String title, String body, int notifId) async {
    // Paramètres Android de la notification
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'notif_channel', // ID du canal
      'Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notifDetails = NotificationDetails(android: androidDetails);

    // Affiche la notification locale
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notifDetails,
    );

    // Marque la notification comme vue dans le stockage local
    await StorageService.marquerCommeVue(notifId);
  }

  @override
  void dispose() {
    // Arrête le timer lorsqu'on quitte la page
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.client != null)
                  Text(
                    "Bienvenue, ${widget.client!.prenom} 👋",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 20),
                _buildResumeCard(), // Carte affichant le solde total
                const SizedBox(height: 24),
                _sectionTitle("Actions rapides"),
                const SizedBox(height: 12),
                _buildQuickActions(), // Grille d’actions rapides
                const SizedBox(height: 32),
                _sectionTitle("Comptes & Assurances"),
                const SizedBox(height: 12),
                _buildAccountList(), // Liste horizontale des comptes
                const SizedBox(height: 32),
                _sectionTitle("Sélectionnés pour vous"),
                const SizedBox(height: 12),
                buildRecommendations(), // Suggestions personnalisées
                const SizedBox(height: 32),
                _sectionTitle("Mes Extras"),
                const SizedBox(height: 12),
                _buildExtrasCard(), // Carte des avantages
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Titre de section
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),
    );
  }

  // Carte avec le solde total de tous les comptes
  Widget _buildResumeCard() {
    final totalSolde = widget.client?.comptes.fold(0.0, (sum, compte) => sum + compte.solde) ?? 0.0;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Solde total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Text("${totalSolde.toStringAsFixed(2)} €", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Grille des actions rapides
  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _quickAction(Icons.send, "Virement", () => context.push('/virements', extra: {
          "client": widget.client
        })),
        _quickAction(Icons.qr_code, "Scanner", () {}),
        _quickAction(Icons.account_balance, "RIB", () => context.push('/rib', extra: widget.client)),
      ],
    );
  }

  // Bouton d’action rapide individuel
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

  // Liste horizontale des comptes du client
  Widget _buildAccountList() {
    return GestureDetector(
      onTap: () => context.push("/detailsCompte", extra: {
        "client": widget.client
      }),
      child: SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.client?.comptes.map((compte) {
            return _buildAccountCard(
              compte.typeCompteNom,
              "${compte.solde} €",
              "À venir : 0.00 €",
            );
          }).toList() ?? [],
        ),
      ),
    );
  }

  // Carte pour un compte individuel
  Widget _buildAccountCard(String title, String balance, String upcoming) {
    return Stack(
      children: [
        Container(
          width: 260,
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(widget.f.format(DateTime.now()), style: const TextStyle(color: Colors.black54)),
              const Spacer(),
              Text(balance, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(upcoming, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        Positioned(
          top: 27,
          right: 40,
          child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  // Recommandations personnalisées
  Widget buildRecommendations() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        // Si tablette, grille. Sinon, listView horizontal
        if (isTablet) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3.5,
            children: _recommendationCards(),
          );
        } else {
          return SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recommendationCards().length,
              itemBuilder: (context, index) => _recommendationCards()[index],
              separatorBuilder: (_, __) => const SizedBox(width: 16),
            ),
          );
        }
      },
    );
  }

  // Liste de widgets pour chaque recommandation
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
        Colors.indigo,
        "Assistance Carte Visa",
        "Bénéficiez d’une assistance voyage 24h/24 et 7j/7.",
      ),
    ];
  }

  // Carte pour une recommandation
  Widget _buildRecommendationCard(IconData icon, Color iconColor, String title, String description) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.black54), maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Carte pour les "Extras" du mois
  Widget _buildExtrasCard() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.blue.shade500, size: 50),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Mes Extras du mois",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Découvrez vos avantages et cashback pour Mars 2025",
                  style: TextStyle(color: Colors.black54),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
