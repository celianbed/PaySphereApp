import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/models/client_model.dart';
import 'package:pay_sphere_app/services/storage.dart';
import 'package:pay_sphere_app/utils/routes.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.android; // Force software rendering
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter router = Routes.routerConfiguration();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PaySphere App',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0; // Valeur de progression de la barre
  bool _isLoading = true; // Suivi de l'état de chargement

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }
  Future<void> _initializeApp() async {
    try {
      await _loadAssets();
      Client? client = await StorageService.getClient();

      print(client);

      if (mounted) {
        context.go('/demarrage', extra: client);
      }
    } catch (e) {
      debugPrint('Erreur au démarrage : $e');
    }
  }


  Future<void> _loadAssets() async {
    // Simuler le préchargement des images et autres ressources
    await Future.delayed(const Duration(milliseconds: 500)); // Temps de préchargement simulé
    await precacheImage(const AssetImage('lib/assets/images/first.jpg'), context);
    await precacheImage(const AssetImage('lib/assets/images/WERO_logo.png'), context);

    // Animer la progression de la barre de chargement
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _progress = i / 10.0;
        });
      }
    }

    // Après la fin de l'animation, finir le chargement
    if (mounted) {
      setState(() {
        _progress = 1.0;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade900, // Couleur de fond mise à jour
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PaySphere',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 250,
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Text(
                'Chargement...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
