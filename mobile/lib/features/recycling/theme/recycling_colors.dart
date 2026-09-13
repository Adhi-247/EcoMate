import 'package:flutter/material.dart';

/// EcoMate Recycling Module Theme Colors
/// Grounded in natural, earthy forest and sage tones.
class RecyclingColors {
  RecyclingColors._();

  // Primary Palette
  static const Color deepForestGreen = Color(0xFF1C3324); // Sidebar / main dark areas / header
  static const Color darkGreen       = Color(0xFF0C190C); // Dark gradients / deep background
  static const Color forestGreen     = Color(0xFF4F6D49); // Buttons, active icons, main accents
  static const Color mediumGreen     = Color(0xFF396331); // Highlights, progress, charts
  static const Color sageGreen       = Color(0xFFB4C09F); // Secondary backgrounds, badge fills
  static const Color lightSage       = Color(0xFFCDD2BB); // Cards, soft accents, borders
  static const Color offWhite        = Color(0xFFF7F7F4); // Main page background
  static const Color white           = Color(0xFFFDFDFD); // Clean card surfaces
  static const Color earthyBrown     = Color(0xFF796F5D); // Secondary text, subtitles, captions
  static const Color oliveGreen      = Color(0xFF697F3D); // Status indicators, open badges

  // Semantic mappings
  static const Color pageBg          = offWhite;
  static const Color cardBg          = white;
  static const Color cardBorder      = Color(0xFFE5E9DD);
  static const Color primaryText     = Color(0xFF111F16);
  static const Color secondaryText   = earthyBrown;
  static const Color accent          = forestGreen;
  static const Color success         = oliveGreen;
  static const Color error           = Color(0xFFBA3C3C);
}
