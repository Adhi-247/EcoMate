import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';
import '../recycling/recycling_centres_screen.dart';
import '../recycling/waste_segregation_guide_screen.dart';

class ResidentDashboard extends StatelessWidget {
  const ResidentDashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071D20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2528),
        elevation: 0,
        title: const Text(
          'Resident Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Color(0xFFE57373)),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B2528),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF163D3F)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to EcoMate ??',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Manage household waste, learn proper segregation, and find nearby recycling facilities.',
                          style: TextStyle(
                            color: Color(0xFF9AB5B1),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Recycling & Waste Guide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Waste Segregation Card
                  _buildOptionCard(
                    title: 'Waste Segregation Guide',
                    subtitle: 'Learn how to sort plastics, paper, organic, and hazardous waste',
                    icon: Icons.menu_book_rounded,
                    color: const Color(0xFF68E1BF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WasteSegregationGuideScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Nearby Centres Card
                  _buildOptionCard(
                    title: 'Find Nearby Recycling Centres',
                    subtitle: 'Locate approved recycling centres and see accepted materials',
                    icon: Icons.location_on_rounded,
                    color: const Color(0xFF38BDF8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecyclingCentresScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B2528),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF163D3F)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF9AB5B1),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF68E1BF),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

