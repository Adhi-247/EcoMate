import 'package:flutter/material.dart';
import '../theme/municipal_colors.dart';

class MunicipalOperationsPage extends StatelessWidget {
  const MunicipalOperationsPage({super.key});

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
          "Operations",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              color: MunicipalColors.secondaryGreen,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              "Operations page coming soon",
              style: TextStyle(
                color: MunicipalColors.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Track active collections and coordinate routes.",
              style: TextStyle(color: MunicipalColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
