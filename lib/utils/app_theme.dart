// lib/utils/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32), // A deeper, more sophisticated green
      brightness: Brightness.light,
      surface: const Color(0xFFF5F5F5), // Off-white background
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Apply background globally
    textTheme: GoogleFonts.outfitTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFF5F5F5), // Match scaffold background
      foregroundColor: Colors.black87,
      elevation: 0, // Remove shadow for a modern flat look
      scrolledUnderElevation: 2, // Add a subtle shadow when scrolling
      titleTextStyle: GoogleFonts.outfit(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide.none, // No border, we use fill color
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      elevation: 1, // Softer shadow
      color: Colors.white,
      surfaceTintColor: Colors.white, // Prevent yellow tint on cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xFF2E7D32),
      unselectedItemColor: Colors.grey.shade600,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  );
}