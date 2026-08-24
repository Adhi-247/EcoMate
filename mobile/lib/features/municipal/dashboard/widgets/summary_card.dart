import 'package:flutter/material.dart';
import '../../theme/municipal_colors.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final Widget? comparisonWidget;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.comparisonWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor ?? MunicipalColors.primaryBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: backgroundColor != null 
              ? iconColor.withValues(alpha: 0.1) 
              : MunicipalColors.border, 
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loose Icon
          Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
          const Spacer(),
          // Value
          Text(
            value,
            style: const TextStyle(
              color: MunicipalColors.primaryText,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          // Title
          Text(
            title,
            style: const TextStyle(
              color: MunicipalColors.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Trend / Comparison
          comparisonWidget ??
              Text(
                subtitle,
                style: const TextStyle(
                  color: MunicipalColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
        ],
      ),
    );
  }
}
