import 'package:flutter/material.dart';

class CollectorDashboard extends StatelessWidget {
  const CollectorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Collector Dashboard',
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}