import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  // ── Playfair Display ──────────────────────────────────────────────

  /// Main page heading (e.g. "My Books" in BooksPage)
  static final TextStyle playfairPageTitle = GoogleFonts.playfairDisplay(
      color: AppColors.onDark,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5);

  /// Standard AppBar title (22 px)
  static final TextStyle playfairAppBarTitle = GoogleFonts.playfairDisplay(
      color: AppColors.onDark,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4);

  /// Section heading (e.g. "Saved Sentences")
  static final TextStyle playfairSectionTitle = GoogleFonts.playfairDisplay(
      color: AppColors.onDark,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3);

  /// Accent card label (e.g. "최근 남긴 문장")
  static final TextStyle playfairAccentLabel = GoogleFonts.playfairDisplay(
      color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w600);

  /// Small accent label (e.g. page number "p. X", "Representative Line")
  static final TextStyle playfairAccentSmall = GoogleFonts.playfairDisplay(
      color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600);

  /// Cover image fallback text (e.g. "No Cover")
  static final TextStyle playfairFallback = GoogleFonts.playfairDisplay(
      color: AppColors.muted, fontSize: 12, letterSpacing: 1.5);

  // Light-theme Playfair styles (used in ThemeData)
  static final TextStyle playfairDisplayLarge = GoogleFonts.playfairDisplay(
      color: AppColors.ink, fontSize: 32, fontWeight: FontWeight.w700);
  static final TextStyle playfairDisplayMedium = GoogleFonts.playfairDisplay(
      color: AppColors.ink, fontSize: 24, fontWeight: FontWeight.w600);
  static final TextStyle playfairTitleLarge = GoogleFonts.playfairDisplay(
      color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w600);

  // ── Noto Serif KR ─────────────────────────────────────────────────

  /// Unstyled base (inherits theme color/size; used for SnackBar content)
  static final TextStyle notoBase = GoogleFonts.notoSerifKr();

  /// Primary book title in hero card
  static final TextStyle notoBookTitle = GoogleFonts.notoSerifKr(
      color: AppColors.onDark,
      fontSize: 22,
      height: 1.35,
      fontWeight: FontWeight.w700);

  /// Author name below book title
  static final TextStyle notoAuthor = GoogleFonts.notoSerifKr(
      color: AppColors.onDarkSecondary,
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w400);

  /// Secondary body text (e.g. async error messages)
  static final TextStyle notoBodySecondary =
      GoogleFonts.notoSerifKr(color: AppColors.onDarkSecondary, fontSize: 14);

  /// Representative sentence displayed in hero
  static final TextStyle notoRepresentativeQuote = GoogleFonts.notoSerifKr(
      color: AppColors.onDark,
      fontSize: 20,
      height: 1.65,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2);

  /// Placeholder text when no representative sentence
  static final TextStyle notoNoRepresentative = GoogleFonts.notoSerifKr(
      color: AppColors.accentWarmTan, fontSize: 15, fontWeight: FontWeight.w500);

  /// Sentence content in list card
  static final TextStyle notoBodyContent = GoogleFonts.notoSerifKr(
      color: AppColors.onDark,
      fontSize: 16,
      height: 1.75,
      fontWeight: FontWeight.w500);

  /// Body text for recent sentence / short content
  static final TextStyle notoBodyMedium = GoogleFonts.notoSerifKr(
      color: AppColors.onDark,
      fontSize: 15,
      height: 1.6,
      fontWeight: FontWeight.w500);

  /// Text field input style
  static final TextStyle notoInput =
      GoogleFonts.notoSerifKr(color: AppColors.onDark, fontSize: 15, height: 1.65);

  /// Text field hint / placeholder style
  static final TextStyle notoHint =
      GoogleFonts.notoSerifKr(color: AppColors.onDarkHint, fontSize: 15);

  /// Form field label
  static final TextStyle notoLabel = GoogleFonts.notoSerifKr(
      color: AppColors.onDarkMuted,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2);

  /// Section subtitle / muted caption
  static final TextStyle notoCaption =
      GoogleFonts.notoSerifKr(color: AppColors.onDarkMuted, fontSize: 13, height: 1.4);

  /// Empty-state primary message
  static final TextStyle notoEmptyTitle =
      GoogleFonts.notoSerifKr(color: AppColors.onDark, fontSize: 18, fontWeight: FontWeight.w700);

  /// Empty-state secondary message
  static final TextStyle notoEmptySubtitle =
      GoogleFonts.notoSerifKr(color: AppColors.onDarkMuted, fontSize: 14, height: 1.6);

  /// Muted text for empty list states (e.g. "아직 등록된 책이 없어요")
  static final TextStyle notoMuted =
      GoogleFonts.notoSerifKr(color: AppColors.muted, fontSize: 15);

  /// Dialog title
  static final TextStyle notoDialogTitle = GoogleFonts.notoSerifKr(
      color: AppColors.onDark, fontSize: 18, fontWeight: FontWeight.w700);

  /// Dialog body text
  static final TextStyle notoDialogBody =
      GoogleFonts.notoSerifKr(color: AppColors.onDarkSecondary, fontSize: 14, height: 1.5);

  /// Dialog cancel / secondary button label
  static final TextStyle notoDialogCancel =
      GoogleFonts.notoSerifKr(color: AppColors.onDarkMuted, fontWeight: FontWeight.w600);

  /// Dialog confirm / accent button label
  static final TextStyle notoDialogConfirm =
      GoogleFonts.notoSerifKr(color: AppColors.accent, fontWeight: FontWeight.w700);

  /// Inline error message
  static final TextStyle notoError =
      GoogleFonts.notoSerifKr(color: AppColors.errorRedSoft, fontSize: 13);

  /// Primary action button label (e.g. "저장하기")
  static final TextStyle notoSaveButton = GoogleFonts.notoSerifKr(
      color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700);

  /// Representative badge chip label
  static final TextStyle notoChipAccent =
      GoogleFonts.notoSerifKr(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w700);

  /// Meta chip label (e.g. sentence count)
  static final TextStyle notoChipMuted = GoogleFonts.notoSerifKr(
      color: AppColors.accentWarmTan, fontSize: 12, fontWeight: FontWeight.w600);

  /// Button label inheriting foreground color (no color set; w700 weight)
  static final TextStyle notoButtonLabel =
      GoogleFonts.notoSerifKr(fontWeight: FontWeight.w700);

  /// Small button label inheriting foreground color (12 px, w700)
  static final TextStyle notoButtonSmall =
      GoogleFonts.notoSerifKr(fontSize: 12, fontWeight: FontWeight.w700);

  /// CTA text on book card when no representative sentence
  static final TextStyle notoCardCta = GoogleFonts.notoSerifKr(
      color: AppColors.accentWarmBeige,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.35);

  /// Opening/closing quote marks on book card
  static final TextStyle notoCardQuoteMark = GoogleFonts.notoSerifKr(
      color: AppColors.accent, fontSize: 26, fontWeight: FontWeight.w600);

  /// Sentence body text on book card (with drop shadow)
  static final TextStyle notoCardQuoteText = GoogleFonts.notoSerifKr(
      color: AppColors.onDark,
      fontSize: 22,
      height: 1.55,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      shadows: const [
        Shadow(
            color: AppColors.shadowDark, blurRadius: 6, offset: Offset(0, 2))
      ]);

  /// Italic attribution line on book card (e.g. "— Book Title")
  static final TextStyle notoAttributionSubtle = GoogleFonts.notoSerifKr(
      color: AppColors.whiteSubtle, fontSize: 13, fontStyle: FontStyle.italic);

  // ── Sentence card (plain TextStyle) ──────────────────────────────

  /// Sentence content on the full-screen share card
  static const TextStyle sentenceCardContent = TextStyle(
      color: AppColors.white,
      fontSize: 18,
      fontStyle: FontStyle.italic,
      height: 1.6);

  /// Book title attribution on the share card
  static const TextStyle sentenceCardAttribution =
      TextStyle(color: AppColors.whiteSubtle, fontSize: 13);
}
