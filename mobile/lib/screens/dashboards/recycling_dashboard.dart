import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';
import '../recycling/recycling_centres_screen.dart';
import '../recycling/waste_segregation_guide_screen.dart';

class RecyclingDashboard extends StatefulWidget {
  const RecyclingDashboard({super.key});

  @override
  State<RecyclingDashboard> createState() => _RecyclingDashboardState();
}

class _RecyclingDashboardState extends State<RecyclingDashboard> {
  final AuthService _authService = AuthService();
  String _userName = 'User';
  String _userRole = 'RECYCLING_OFFICER';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final name = await _authService.getToken();
    final role = await _authService.getRole();
    if (mounted && role != null) {
      setState(() {
        _userRole = role;
        _userName = name != null && name.isNotEmpty ? 'Officer' : 'User';
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _authService.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF12383A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.recycling_rounded,
                color: Color(0xFF65E0BD),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Recycling Hub',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFE57373)),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Welcome Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0B2F33), Color(0xFF072124)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1B484C)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '?? Component 3',
                              style: TextStyle(
                                color: Color(0xFF68E1BF),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF113D40),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _userRole.replaceAll('ROLE_', ''),
                                style: const TextStyle(
                                  color: Color(0xFFBBE5DE),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Recycling & Sustainable Waste Management',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Welcome, $_userName! Access segregation guides, search materials, and discover approved recycling centres nearby.',
                          style: const TextStyle(
                            color: Color(0xFF9AB5B1),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quick Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          count: '7',
                          label: 'Waste Categories',
                          icon: Icons.category_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          count: '5',
                          label: 'Active Centres',
                          icon: Icons.storefront_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          count: '100%',
                          label: 'Segregation Verified',
                          icon: Icons.verified_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Section Title
                  const Text(
                    'Sprint 1 Features',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Feature Card 1: SCRUM-53
                  _buildFeatureCard(
                    title: 'Waste Segregation Guide',
                    subtitle:
                        'Browse categories, separation steps, and search any household item.',
                    icon: Icons.menu_book_rounded,
                    tag: 'SCRUM-53',
                    accentColor: const Color(0xFF68E1BF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WasteSegregationGuideScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // Feature Card 2 & 3: SCRUM-54 & SCRUM-55
                  _buildFeatureCard(
                    title: 'Nearby Recycling Centres & Materials',
                    subtitle:
                        'Find active centres by location, check accepted materials & operating hours.',
                    icon: Icons.map_rounded,
                    tag: 'SCRUM-54 & 55',
                    accentColor: const Color(0xFF38BDF8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecyclingCentresScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // Eco Tip of the day Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B2528),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF154446)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_rounded,
                          color: Color(0xFFFBBF24),
                          size: 24,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Eco Tip: Rinsing Plastics',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Rinsing food containers and bottles prevents contamination in recycling machinery and boosts recovery efficiency by over 90%!',
                                style: TextStyle(
                                  color: Color(0xFF9AB5B1),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String count,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B2528),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF163D3F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF68E1BF), size: 20),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7B9F9A),
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String tag,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B2528),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF163D3F)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Icon(icon, color: accentColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF9AB5B1),
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
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

