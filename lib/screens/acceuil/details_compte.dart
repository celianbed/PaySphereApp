import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/client_model.dart';
import 'package:intl/intl.dart';
import '../autres/custom_app_bar.dart';
import '../autres/navigation_wrapper.dart';

class TransactionsCartePage extends StatelessWidget {
  final Client? client;
  final f = DateFormat('dd/MM/yyyy');

  TransactionsCartePage({super.key, required this.client});

  final List<Map<String, dynamic>> transactions = [
    {
      "title": "Amazon.fr",
      "amount": -59.99,
      "date": DateTime(2025, 5, 26),
      "status": "Confirmée"
    },
    {
      "title": "McDonald's",
      "amount": -12.30,
      "date": DateTime(2025, 5, 25),
      "status": "Confirmée"
    },
    {
      "title": "Apple Music",
      "amount": -9.99,
      "date": DateTime(2025, 5, 24),
      "status": "En attente"
    },
    {
      "title": "Pharmacie Centrale",
      "amount": -23.45,
      "date": DateTime(2025, 5, 22),
      "status": "Confirmée"
    },
    {
      "title": "Super U",
      "amount": -87.10,
      "date": DateTime(2025, 5, 21),
      "status": "Confirmée"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 1,
      client: client,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomAppBar(
            title: 'Transactions carte',
            showNotifications: false,
            onBack: () => context.pop(),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final isPending = transaction['status'].toLowerCase() != 'confirmée';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: isPending ? Colors.orange.shade100 : Colors.blue.shade100,
                    child: Icon(
                      Icons.shopping_cart,
                      color: isPending ? Colors.orange : Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction['title'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${transaction['amount'].toStringAsFixed(2)} €",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transaction['status'],
                          style: TextStyle(
                            color: isPending ? Colors.orange.shade800 : Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          f.format(transaction['date']),
                          style: const TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
