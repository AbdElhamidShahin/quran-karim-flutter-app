import 'package:flutter/material.dart';
import 'color.dart';

// ─── Surah name (Arabic, for list headings) ────────────────────────────────────
TextStyle surahNameArStyle() => const TextStyle(
      fontFamily: 'Lalezar',
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: textPrimary,
      letterSpacing: 0.3,
    );

// ─── Surah transliteration / English ──────────────────────────────────────────
TextStyle surahNameEnStyle() => const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textSecondary,
      letterSpacing: 0.3,
    );

// ─── Verse / ayah count chip ───────────────────────────────────────────────────
TextStyle ayahCountStyle() => const TextStyle(
      fontFamily: 'Cairo',
      fontSize: 13,
      color: textDisabled,
    );

// ─── General body text ─────────────────────────────────────────────────────────
TextStyle appBodyStyle() => const TextStyle(
      fontFamily: 'Cairo',
      fontSize: 15,
      height: 1.6,
      color: primaryDark,
    );

// ─── AppBar title ──────────────────────────────────────────────────────────────
TextStyle appBarTitleStyle() => const TextStyle(
      fontFamily: 'Lalezar',
      fontSize: 24,
      color: primaryColor,
      letterSpacing: 0.8,
    );

// ─── Section header ────────────────────────────────────────────────────────────
TextStyle sectionHeaderStyle() => const TextStyle(
      fontFamily: 'Cairo',
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: primaryDark,
      height: 1.4,
    );

// ─── Button / label text ───────────────────────────────────────────────────────
TextStyle buttonTextStyle() => const TextStyle(
      fontFamily: 'Cairo',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textSecondary,
      letterSpacing: 0.3,
    );

// ─── Surah number inside circle ────────────────────────────────────────────────
TextStyle surahNumberCircleStyle() => const TextStyle(
      fontFamily: 'Cairo',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primaryDark,
    );

// ─── Quran image-page display (not text rendering — images are used) ───────────
TextStyle quranAyahStyle() => const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      height: 2.2,
      color: textPrimary,
    );

// ─── Selected/highlighted ayah ─────────────────────────────────────────────────
TextStyle selectedAyahStyle() => const TextStyle(
      fontFamily: 'Cairo',
      fontSize: 19,
      fontWeight: FontWeight.w500,
      height: 2.0,          // generous height for fully-vocalized Arabic
      color: primaryDark,
      letterSpacing: 0.2,
    );

// ─── Tafsir / explanation body ─────────────────────────────────────────────────
TextStyle tafsirTextStyle() => TextStyle(
      fontFamily: 'Cairo',
      fontSize: 14,
      height: 1.7,
      color: textPrimary.withOpacity(0.85),
    );

// ─── Sajda marker ──────────────────────────────────────────────────────────────
TextStyle sajdaMarkerStyle() => const TextStyle(
      fontFamily: 'Cairo',
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: primaryDark,
    );

// ─── Juz number (large display) ────────────────────────────────────────────────
TextStyle juzNumberStyle() => const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: primaryDark,
    );

// ─── Settings item ─────────────────────────────────────────────────────────────
TextStyle SttingsTextStyle() => const TextStyle(
      fontFamily: 'Cairo',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: primaryDark,
    );
