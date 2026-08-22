import 'package:flutter/material.dart';
import 'screens/auth_wrapper.dart';

void main() {
  runApp(const EcoMateApp());
}

class EcoMateApp extends StatelessWidget {
  const EcoMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoMate',
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}