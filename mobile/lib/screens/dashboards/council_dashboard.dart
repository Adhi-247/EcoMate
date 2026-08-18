import 'package:flutter/material.dart';

class CouncilDashboard extends StatelessWidget {
  const CouncilDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Council Dashboard',
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}