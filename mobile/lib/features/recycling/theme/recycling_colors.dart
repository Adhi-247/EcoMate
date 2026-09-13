import 'package:flutter/material.dart';

/// EcoMate Recycling Module Theme Colors
/// Unified with EcoMate Login and Municipal Brand Design System (Teal & Emerald).
class RecyclingColors {
  RecyclingColors._();

  // Primary Brand Colors (From LoginScreen & Municipal theme)
  static const Color darkPrimary     = Color(0xFF074047); // Deep teal primary
  static const Color deepForestGreen = Color(0xFF074047); // Deep teal header & card accents
  static const Color darkGreen       = Color(0xFF15292E); // Deep slate teal (Login darkPrimary)
  static const Color forestGreen     = Color(0xFF1DA27E); // Vibrant emerald (Login accent, buttons)
  static const Color mediumGreen     = Color(0xFF028B6B); // Secondary brand green (Municipal)
  static const Color sageGreen       = Color(0xFF02C397); // Crisp mint for status & badges
  static const Color lightSage       = Color(0xFFD8EBE6); // Clean soft borders and light accents
  static const Color offWhite        = Color(0xFFF7FAFA); // Crisp clean page background (matches Login)
  static const Color white           = Color(0xFFFFFFFF); // Pure white cards
  static const Color earthyBrown     = Color(0xFF64748B); // Slate neutral for subtitles & secondary text
  static const Color oliveGreen      = Color(0xFF1DA27E); // Vibrant green for Open status

  // Semantic mappings
  static const Color pageBg          = offWhite;
  static const Color cardBg          = white;
  static const Color cardBorder      = Color(0xFFD5E0E0);
  static const Color primaryText     = Color(0xFF15292E);
  static const Color secondaryText   = earthyBrown;
  static const Color accent          = forestGreen;
  static const Color success         = Color(0xFF1DA27E);
  static const Color error           = Color(0xFFFF6B6B);
}
