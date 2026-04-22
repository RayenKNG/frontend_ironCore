import 'package:flutter/material.dart';

class AppTheme {
  // ── Color Palette ──────────────────────────────────────
  static const Color primary    = Color(0xFFE8192C);
  static const Color primaryDark = Color(0xFFB5111F);
  static const Color bgBase     = Color(0xFF0A0A0B);
  static const Color bgSurface  = Color(0xFF111113);
  static const Color bgCard     = Color(0xFF18181B);
  static const Color bgElement  = Color(0xFF1F1F23);
  static const Color border     = Color(0xFF2A2A2A);
  static const Color textPrimary   = Color(0xFFF2F2F3);
  static const Color textSecondary = Color(0xFF9999A6);
  static const Color textHint      = Color(0xFF5A5A6A);
  static const Color gold   = Color(0xFFF5A623);
  static const Color green  = Color(0xFF22C55E);
  static const Color orange = Color(0xFFFF6B35);

  // ── Dark Theme ──────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgBase,
    primaryColor: primary,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: bgSurface,
      error: primary,
    ),
    fontFamily: 'DmSans',
    appBarTheme: const AppBarTheme(
      backgroundColor: bgSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
      iconTheme: IconThemeData(color: textSecondary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bgSurface,
      selectedItemColor: primary,
      unselectedItemColor: textHint,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size.fromHeight(48),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: textHint, fontSize: 14),
      labelStyle: const TextStyle(color: textSecondary, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
