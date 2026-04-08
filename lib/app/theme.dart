import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _cream = Color(0xFFF7F3EE);
  static const _ink = Color(0xFF1C1917);
  static const _muted = Color(0xFF78716C);
  static const _accent = Color(0xFFC2773A);
  static const _cardBg = Color(0xFFEFEBE4);
  static const _border = Color(0xFFDDD8D0);

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final notoTextTheme =
        GoogleFonts.notoSerifKrTextTheme(base.textTheme).apply(
      bodyColor: _ink,
      displayColor: _ink,
    );
    return base.copyWith(
      scaffoldBackgroundColor: _cream,
      colorScheme: base.colorScheme.copyWith(
        surface: _cream,
        onSurface: _ink,
        primary: _accent,
        onPrimary: Colors.white,
        secondary: _muted,
        outline: _border,
      ),
      textTheme: notoTextTheme.copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
            color: _ink, fontSize: 32, fontWeight: FontWeight.w700),
        displayMedium: GoogleFonts.playfairDisplay(
            color: _ink, fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.playfairDisplay(
            color: _ink, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _cream,
        foregroundColor: _ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: _ink),
        titleTextStyle: GoogleFonts.playfairDisplay(
            color: _ink, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _cream,
        selectedItemColor: _accent,
        unselectedItemColor: _muted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      cardTheme: CardTheme(
        color: _cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerColor: _border,
    );
  }
}
