import 'package:flutter/material.dart';
import '../../models/recycling_centre.dart';

class CentreDetailScreen extends StatelessWidget {
  final RecyclingCentre centre;

  const CentreDetailScreen({
    super.key,
    required this.centre,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071D20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2528),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF68E1BF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          centre.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Centre Overview Header Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B2528),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF163D3F)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF68E1BF).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF68E1BF).withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.storefront_rounded,
                              color: Color(0xFF68E1BF),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  centre.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: centre.isOpen
                                            ? const Color(0xFF0B2E26)
                                            : const Color(0xFF33151E),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: centre.isOpen
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFEF4444),
                                        ),
                                      ),
                                      child: Text(
                                        centre.isOpen ? 'OPEN NOW' : 'CLOSED',
                                        style: TextStyle(
                                          color: centre.isOpen
                                              ? const Color(0xFF34D399)
                                              : const Color(0xFFF87171),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF102D2F),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${centre.distanceKm} km away',
                                        style: const TextStyle(
                                          color: Color(0xFF68E1BF),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFF163D3F)),
                      const SizedBox(height: 12),

                      // Location
                      _buildInfoRow(
                        icon: Icons.location_on_rounded,
                        label: 'Address',
                        value: centre.address,
                      ),
                      const SizedBox(height: 10),

                      // Operating Hours
                      _buildInfoRow(
                        icon: Icons.access_time_filled_rounded,
                        label: 'Hours',
                        value: centre.operatingHours,
                      ),
                      const SizedBox(height: 10),

                      // Phone
                      _buildInfoRow(
                        icon: Icons.phone_rounded,
                        label: 'Phone',
                        value: centre.contactNumber,
                      ),
                      const SizedBox(height: 10),

                      // Email
                      _buildInfoRow(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        value: centre.email,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Accepted Materials (SCRUM-55)
                _buildSectionHeader(
                  title: 'Accepted Recyclable Materials',
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B2528),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF135B49)),
                  ),
                  child: Column(
                    children: centre.acceptedMaterials.map((material) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0B2E26),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Color(0xFF34D399),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                material,
                                style: const TextStyle(
                                  color: Color(0xFFE2F3F0),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Unsupported Materials Warning Card (SCRUM-55)
                _buildSectionHeader(
                  title: 'Unsupported / Rejected Materials',
                  icon: Icons.warning_rounded,
                  color: const Color(0xFFEF4444),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF281116),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF5E1E28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please DO NOT bring the following items to this centre:',
                        style: TextStyle(
                          color: Color(0xFFFCA5A5),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...centre.unsupportedMaterials.map((material) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.do_not_disturb_on_rounded,
                                color: Color(0xFFEF4444),
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  material,
                                  style: const TextStyle(
                                    color: Color(0xFFFECACA),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Additional Notes
                if (centre.notes.isNotEmpty) ...[
                  _buildSectionHeader(
                    title: 'Centre Notes & Drop-off Policy',
                    icon: Icons.info_outline_rounded,
                    color: const Color(0xFF68E1BF),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E2F32),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1B484A)),
                    ),
                    child: Text(
                      centre.notes,
                      style: const TextStyle(
                        color: Color(0xFFC7DFDC),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF68E1BF), size: 18),
        const SizedBox(width: 10),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7A9E99),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFFD8EBE8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

