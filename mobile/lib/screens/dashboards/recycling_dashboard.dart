import 'package:flutter/material.dart';

class RecyclingDashboard
 extends StatelessWidget {
  const RecyclingDashboard
({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Recycling Dashboard',
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}