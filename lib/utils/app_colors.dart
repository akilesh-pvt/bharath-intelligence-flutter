import 'package:flutter/material.dart';

/// Performance-optimized Light Green Theme Colors
/// Avoiding blue colors as per requirements
class AppColors {
  // Primary - Light Green Palette
  static const Color primary = Color(0xFF4CAF50);           
  static const Color primaryLight = Color(0xFF81C784);      
  static const Color primaryDark = Color(0xFF388E3C);       
  
  // Accent & Surface
  static const Color accent = Color(0xFF8BC34A);            
  static const Color surface = Color(0xFFFFFFFF);           
  static const Color background = Color(0xFFF8F9FA);        
  static const Color surfaceLight = Color(0xFFF1F8E9);      
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1B5E20);       
  static const Color textSecondary = Color(0xFF4E4E4E);     
  static const Color textLight = Color(0xFF757575);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);           
  static const Color warning = Color(0xFFFF9800);           
  static const Color error = Color(0xFFE57373);             
  static const Color pending = Color(0xFFFFC107);           
  
  // Performance-optimized gradients
  static const List<Color> primaryGradient = [
    Color(0xFF66BB6A), 
    Color(0xFF4CAF50),
  ];
  
  static const List<Color> surfaceGradient = [
    Color(0xFFF1F8E9), 
    Color(0xFFFFFFFF),
  ];
  
  // Card and divider colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  
  // Button colors
  static const Color buttonDisabled = Color(0xFFBDBDBD);
  static const Color buttonText = Color(0xFFFFFFFF);
  
  /// Get Material Color Swatch for primary color
  static MaterialColor get primarySwatch {
    return const MaterialColor(0xFF4CAF50, {
      50: Color(0xFFE8F5E8),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(0xFF4CAF50),
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    });
  }
}