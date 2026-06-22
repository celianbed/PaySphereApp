import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_sphere_app/api/api_client.dart';
import 'package:pay_sphere_app/models/client_model.dart';
import 'package:pay_sphere_app/services/notification_service.dart';
import 'package:pay_sphere_app/services/storage.dart';
import 'package:pay_sphere_app/utils/routes.dart';
import 'package:intl/date_symbol_data_local.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('fr_FR');

  ApiClient.onSessionExpired = (message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      NotificationService.stop();
      GoRouter.of(context).go('/login');
    }
  };

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
  double _progress = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _loadAssets();
      Client? client = await StorageService.getClient();
      NotificationService.initialize(
          context, flutterLocalNotificationsPlugin);

      if (mounted) {
        context.go('/demarrage', extra: client);
      }
    } catch (e) {
      debugPrint('Erreur au démarrage : $e');
    }
  }

  void requestNotificationPermission() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> _loadAssets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await precacheImage(
        const AssetImage('lib/assets/images/first.jpg'), context);
    await precacheImage(
        const AssetImage('lib/assets/images/WERO_logo.png'), context);

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _progress = i / 10.0;
        });
      }
    }
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
          color: Colors.blue.shade900,
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
