import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/client_model.dart';

class ConfirmationPage extends StatelessWidget {
  final String titre;
  final String message;
  final VoidCallback? onFinish;
  final Client? client;
  final String? futurePush;

  const ConfirmationPage({
    super.key,
    required this.titre,
    required this.message,
    required this.onFinish,
    required this.client,
    required this.futurePush,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: Colors.blue.shade700),
            const SizedBox(height: 30),
            Text(
              titre,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(context.mounted) {
                    context.push(futurePush!,extra: {
                      "client" : client,
                      "carte" : client?.comptes[0].cartes[0],
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Terminer', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
