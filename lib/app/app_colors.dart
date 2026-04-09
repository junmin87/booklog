import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Base ──────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E); // shell nav unselected

  // ── Light theme ───────────────────────────────────────────────────
  static const Color cream = Color(0xFFF7F3EE);
  static const Color ink = Color(0xFF1C1917);
  static const Color muted = Color(0xFF78716C);
  static const Color accent = Color(0xFFC2773A);
  static const Color cardBg = Color(0xFFEFEBE4);
  static const Color border = Color(0xFFDDD8D0);

  // ── Dark theme backgrounds ────────────────────────────────────────
  static const Color darkBg = Color(0xFF0F0E0C);
  static const Color darkCard = Color(0xFF171512);
  static const Color darkCardAlt = Color(0xFF1B1714);
  static const Color darkCardRepresentative = Color(0xFF1F1A16);
  static const Color darkSurface = Color(0xFF211D19);
  static const Color darkOverlayCard = Color(0xE61B1B1B);

  // ── Dark theme text ───────────────────────────────────────────────
  static const Color onDark = Color(0xFFF7F3EE);
  static const Color onDarkSecondary = Color(0xFFD6D3D1);
  static const Color onDarkMuted = Color(0xFFA8A29E);
  static const Color onDarkHint = Color(0xFF57534E);
  static const Color onDarkDisabled = Color(0xFF6B625B);

  // ── Accent variants ───────────────────────────────────────────────
  static const Color accentWarmTan = Color(0xFFC9A382);
  static const Color accentWarmBeige = Color(0xFFFFD7B8);

  // ── Semantic ──────────────────────────────────────────────────────
  static const Color errorRed = Color(0xFFF44336);
  static const Color errorRedSoft = Color(0xFFE57373);
  static const Color successSnackBarBg = Color(0xFF2A241F);
  static const Color errorSnackBarBg = Color(0xFF5C2B2B);

  // ── Overlays ──────────────────────────────────────────────────────
  static const Color overlayHeavy = Color(0xF2000000);
  static const Color overlayStrong = Color(0xD9000000);
  static const Color overlayMid = Color(0x70000000);
  static const Color overlayFaint = Color(0x35000000);
  static const Color overlayLoading = Color(0x42000000); // Colors.black26
  static const Color overlayBlack87 = Color(0xDD000000); // Colors.black87
  static const Color shadowDark = Color(0x99000000);
  static const Color whiteSubtle = Color(0xB3FFFFFF);    // white @ 70% opacity
}
