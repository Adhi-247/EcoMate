import 'package:flutter/material.dart';
import '../theme/municipal_colors.dart';

class MunicipalSchedulePage extends StatelessWidget {
  const MunicipalSchedulePage({super.key});

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
          "Schedule Calendar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color: MunicipalColors.secondaryGreen,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              "Schedules page coming soon",
              style: TextStyle(
                color: MunicipalColors.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Schedule collection routes and shifts here.",
              style: TextStyle(color: MunicipalColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
