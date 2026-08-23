import 'package:flutter/material.dart';
import '../theme/municipal_colors.dart';

class MunicipalReportsPage extends StatelessWidget {
  const MunicipalReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MunicipalColors.pageBg,
      appBar: AppBar(
        backgroundColor: MunicipalColors.primaryBg,
        foregroundColor: MunicipalColors.primaryText,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: MunicipalColors.border,
            height: 1,
          ),
        ),
        title: const Text(
          "Complaints & Reports",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: MunicipalColors.secondaryGreen,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              "Reports page coming soon",
              style: TextStyle(
                color: MunicipalColors.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Review overflowing bins and illegal dump sites.",
              style: TextStyle(color: MunicipalColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
