import 'package:flutter/material.dart';
import 'package:pay_sphere_app/screens/accueil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaySphere App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AccueilPage(),
    );
  }
}


