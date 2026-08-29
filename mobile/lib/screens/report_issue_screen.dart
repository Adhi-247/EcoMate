import 'package:flutter/material.dart';

class ReportIssueScreen extends StatelessWidget {
  const ReportIssueScreen({super.key});

  static const darkGreen = Color(0xFF024B45);
  static const green = Color(0xFF028B6B);
  static const lightGreen = Color(0xFF02C397);
  static const background = Color(0xFFF2FAF7);
  static const border = Color(0xFFD8EBE6);
  static const text = Color(0xFF0F172A);
  static const secondaryText = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: darkGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Report New Issue',
          style: TextStyle(color: darkGreen, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const _ProgressSteps(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
              children: const [
                Text(
                  'Select Issue Type',
                  style: TextStyle(color: text, fontSize: 19, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 14),
                _IssueCard(
                  title: 'Illegal Dumping',
                  description: 'Report waste dumped in unauthorized places.',
                  icon: Icons.delete_forever_rounded,
                  iconColor: Color(0xFFFF6B6B),
                  iconBackground: Color(0xFFFFD9DC),
                  selected: true,
                ),
                _IssueCard(
                  title: 'Overflowing Bin',
                  description: 'Report bins that are full or overflowing.',
                  icon: Icons.delete_outline_rounded,
                  iconColor: green,
                  iconBackground: Color(0xFFD5F6D2),
                ),
                _IssueCard(
                  title: 'Damaged Bin',
                  description: 'Report damaged or broken public bins.',
                  icon: Icons.warning_rounded,
                  iconColor: darkGreen,
                  iconBackground: Color(0xFFD9F4DC),
                ),
                _IssueCard(
                  title: 'Missed Cleanup',
                  description: 'Report missed waste collection/cleanup.',
                  icon: Icons.local_shipping_rounded,
                  iconColor: green,
                  iconBackground: Color(0xFFD5F6D2),
                ),
                _IssueCard(
                  title: 'Other Issue',
                  description: 'Any other waste-related problem.',
                  icon: Icons.help_outline_rounded,
                  iconColor: secondaryText,
                  iconBackground: Color(0xFFE2E5E6),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            height: 44,
            width: double.infinity,
            decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: const Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _ProgressSteps extends StatelessWidget {
  const _ProgressSteps();

  @override
  Widget build(BuildContext context) {
    const labels = ['Type', 'Location', 'Details', 'Review'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: List.generate(labels.length, (index) {
          final active = index == 0;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0) const Expanded(child: Divider(color: ReportIssueScreen.border, height: 1)),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: active ? ReportIssueScreen.darkGreen : const Color(0xFFE2E4E4),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: active ? Colors.white : ReportIssueScreen.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (index < labels.length - 1) const Expanded(child: Divider(color: ReportIssueScreen.border, height: 1)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  labels[index],
                  style: TextStyle(
                    color: active ? ReportIssueScreen.darkGreen : ReportIssueScreen.secondaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.selected = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? ReportIssueScreen.green : ReportIssueScreen.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconBackground, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: ReportIssueScreen.text, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(description, style: const TextStyle(color: ReportIssueScreen.secondaryText, fontSize: 11.5, height: 1.25)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: ReportIssueScreen.darkGreen),
        ],
      ),
    );
  }
}
