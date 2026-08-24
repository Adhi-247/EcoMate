import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../../services/auth_service.dart';
import '../login_screen.dart';
import '../recycling/waste_segregation_guide_screen.dart';
=======
import '../../features/municipal/navigation/municipal_bottom_nav.dart';
>>>>>>> developer

class CouncilDashboard extends StatelessWidget {
  const CouncilDashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: const Text('Council Dashboard'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Council Dashboard',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WasteSegregationGuideScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_note),
                label: const Text('Waste Segregation Guide'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
=======
    return const MunicipalBottomNav();
>>>>>>> developer
  }
}