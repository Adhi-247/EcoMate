import 'package:flutter/material.dart';
import '../../models/waste_category.dart';

class CategoryDetailScreen extends StatelessWidget {
  final WasteCategory category;

  const CategoryDetailScreen({
    super.key,
    required this.category,
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
          category.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card with Category Icon & Bin Color
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B2528),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF163D3F)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: category.binColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: category.binColor.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          category.icon,
                          color: category.binColor,
                          size: 38,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: category.binColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: category.binColor.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                'Bin: ${category.binColorName}',
                                style: TextStyle(
                                  color: category.binColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Description
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E2F32),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1B484A)),
                  ),
                  child: Text(
                    category.description,
                    style: const TextStyle(
                      color: Color(0xFFB4CCC9),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Common Examples Section
                _buildSectionHeader(
                  title: 'Common Waste Examples',
                  icon: Icons.checklist_rounded,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: category.commonItems.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF103337),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1C4D52)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: category.binColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item,
                            style: const TextStyle(
                              color: Color(0xFFD6EBE7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // Step-by-Step Preparation
                _buildSectionHeader(
                  title: 'How to Prepare & Separate',
                  icon: Icons.format_list_numbered_rounded,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B2528),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF163D3F)),
                  ),
                  child: Column(
                    children: List.generate(category.preparationSteps.length, (i) {
                      final step = category.preparationSteps[i];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: i < category.preparationSteps.length - 1 ? 14 : 0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF68E1BF).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF68E1BF),
                                ),
                              ),
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Color(0xFF68E1BF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                step,
                                style: const TextStyle(
                                  color: Color(0xFFC7DFDC),
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 28),

                // Dos & Don'ts
                _buildSectionHeader(
                  title: 'Disposal Best Practices',
                  icon: Icons.thumb_up_alt_outlined,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DOs
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B2E26),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF135B49)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'DO',
                                  style: TextStyle(
                                    color: Color(0xFF34D399),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...category.dos.map((d) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '• $d',
                                style: const TextStyle(
                                  color: Color(0xFFA7F3D0),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // DON'Ts
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF33151E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF6B2135)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'DON\'T',
                                  style: TextStyle(
                                    color: Color(0xFFF87171),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...category.donts.map((dont) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '• $dont',
                                style: const TextStyle(
                                  color: Color(0xFFFECACA),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF68E1BF), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

