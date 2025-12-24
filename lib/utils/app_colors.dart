import 'package:flutter/material.dart';

class AppColors {
  // Primary Medical Colors
  static const Color primaryBlue = Color(0xFF2E86AB);
  static const Color secondaryBlue = Color(0xFF4A90B8);
  static const Color lightBlue = Color(0xFFE3F2FD);
  
  // Medical Red (Heart/Urgency)
  static const Color medicalRed = Color(0xFFE53E3E);
  static const Color lightRed = Color(0xFFFFEBEE);
  
  // Clean Medical White/Gray
  static const Color backgroundWhite = Color(0xFFFAFAFA);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);
  
  // Success/Warning Colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, secondaryBlue],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardWhite, lightGray],
  );
  
  // Shadow Colors
  static const Color shadowColor = Color(0x1A000000);
  static const Color cardShadow = Color(0x0D000000);
}