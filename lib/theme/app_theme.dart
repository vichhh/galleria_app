import 'package:flutter/material.dart';

class AppTheme {
  // Backgrounds
  static const bg1 = Color(0xFF0E0F12);
  static const bg2 = Color(0xFF14151A);
  static const surface = Color(0xFF191B21);

  // Accents (orange)
  static const accentStart = Color(0xFFFF8A3D);
  static const accentEnd = Color(0xFFFF5A0A);

  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;

  static const showroomGradient = LinearGradient(
    colors: [bg1, bg2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accentGradient = LinearGradient(
    colors: [accentStart, accentEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}