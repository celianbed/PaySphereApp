import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/client_model.dart';
import '../autres/navigation_wrapper.dart';
import '../autres/custom_app_bar.dart';

class ContactPage extends StatelessWidget {
  final Client? client;

  const ContactPage({super.key, required this.client});

  Widget _buildCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: child,
    );
  }

  Widget _buildLine(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 28, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 2,
      client: client,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          title: 'Contact',
          showNotifications: true,
          client: client,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCard(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (client != null)
                  Text(
                    "Mon conseiller",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                const SizedBox(height: 10),
                _buildLine(Icons.phone, 'Appeler', '', () {
                  launchUrl(Uri.parse('tel:+33800000000'));
                }),
                _buildLine(Icons.mail_outline, 'Échanger par message', 'Obtenez une réponse sous 72h ouvrées.', () {}),
                _buildLine(Icons.calendar_today, 'Prendre un rendez-vous', 'Consultez ou réservez un rendez-vous.', () {}),
              ],
            )),
            const SizedBox(height: 10),
            const Text("Assistance immédiate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text("La plupart des problèmes rencontrés peuvent être résolus en quelques minutes."),
            const SizedBox(height: 10),
            _buildCard(
              ListTile(
                leading: const Icon(Icons.smart_toy, color: Colors.blue),
                title: const Text("Rechercher une solution"),
                subtitle: const Text("Assistant virtuel"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const ChatbotPage(),
                  ));
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text("Autres agences", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text("Vous souhaitez réaliser une opération dans un autre lieu ?"),
            const SizedBox(height: 10),
            _buildCard(
              Column(
                children: [
                  ListTile(
                    title: const Text("Rechercher une agence ou un distributeur ?"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 0),
                  ListTile(
                    title: const Text("Trouver un distributeur à l'étranger ?"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<_ChatMessage> _messages = [
    _ChatMessage("Bonjour ! Je suis l'assistant PaySphere. Comment puis-je vous aider ?", false),
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const Map<String, String> _faq = {
    "virement": "Pour effectuer un virement, rendez-vous dans Paiements > Virements > Nouveau virement. Vous aurez besoin de l'IBAN du bénéficiaire.",
    "carte": "Vous pouvez gérer votre carte depuis Paiements > Cartes. Vous pouvez l'opposer, activer/désactiver le sans contact et les paiements en ligne.",
    "opposition": "Pour opposer votre carte, allez dans Paiements > Cartes > votre carte > Opposition. L'opposition est immédiate et irréversible.",
    "plafond": "Votre plafond de paiement est visible dans les détails de votre carte. Il se réinitialise tous les 30 jours.",
    "rib": "Votre RIB est accessible depuis Paiements > RIB. Vous pouvez le télécharger en PDF.",
    "mot de passe": "Pour changer votre mot de passe, allez dans Profil > Changer le mot de passe.",
    "conseiller": "Vous pouvez contacter votre conseiller depuis la page Contact : par téléphone, message ou en prenant rendez-vous.",
    "notification": "Vos notifications sont accessibles via l'icône cloche en haut à droite de l'écran d'accueil.",
    "solde": "Votre solde est affiché sur la page d'accueil. Appuyez sur votre compte pour voir le détail.",
    "wero": "Wero vous permet d'envoyer de l'argent instantanément avec juste un numéro de téléphone ou une adresse e-mail.",
    "apple pay": "Apple Pay est disponible dans Paiements > Plus d'options. Vous pouvez y ajouter votre carte pour payer en magasin et en ligne.",
    "beneficiaire": "Gérez vos bénéficiaires depuis Paiements > Virements > Bénéficiaires. Vous pouvez en ajouter ou en supprimer.",
  };

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text, true));
    });
    _controller.clear();

    Future.delayed(const Duration(milliseconds: 400), () {
      final response = _getResponse(text.toLowerCase());
      setState(() {
        _messages.add(_ChatMessage(response, false));
      });
      _scrollToBottom();
    });
  }

  String _getResponse(String input) {
    for (final entry in _faq.entries) {
      if (input.contains(entry.key)) {
        return entry.value;
      }
    }
    return "Je n'ai pas trouvé de réponse à votre question. Vous pouvez contacter votre conseiller depuis la page Contact pour une aide personnalisée.";
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Assistant PaySphere"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildBubble(msg);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Wrap(
              spacing: 8,
              children: ["Virement", "Carte", "RIB", "Plafond", "Wero"].map((label) {
                return ActionChip(
                  label: Text(label),
                  onPressed: () => _sendMessage(label),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Posez votre question...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(_ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isUser ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage(this.text, this.isUser);
}
