import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Dashboard Mahasiswa D4TI';
  static const String appVersion = '1.0.0';

  static const String userPrefsKey = 'user_prefs';

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Dashboard Gradient Colors
  static const List<List<Color>> dashboardGradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)], // Purple
    [Color(0xFFf093fb), Color(0xFFf5576c)], // Pink
    [Color(0xFF4facfe), Color(0xFF00f2fe)], // Blue
    [Color(0xFF43e97b), Color(0xFF38f9d7)], // Green
  ];

  // Individual Gradient Colors (optional - for direct access)
  static const List<Color> gradientPurple = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
  ];
  static const List<Color> gradientPink = [
    Color(0xFFf093fb),
    Color(0xFFf5576c),
  ];
  static const List<Color> gradientBlue = [
    Color(0xFF4facfe),
    Color(0xFF00f2fe),
  ];
  static const List<Color> gradientGreen = [
    Color(0xFF43e97b),
    Color(0xFF38f9d7),
  ];
}
