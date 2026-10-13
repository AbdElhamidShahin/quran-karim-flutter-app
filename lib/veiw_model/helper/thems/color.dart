import 'package:flutter/material.dart';

// ─── Brand Colors ──────────────────────────────────────────────────────────────
const Color primaryColor      = Color(0xFF3D9E8C); // Teal — main brand
const Color primaryDark       = Color(0xFF2A5F5A); // Deep teal — headers/emphasis
const Color primaryLight      = Color(0xFF9AD0C2); // Light teal — subtle accents
const Color accentColor       = Color(0xFFC9A84C); // Gold — Islamic decorative only
const Color continar          = Color(0xFF3D9E8C); // alias for primary (used in badges)

// ─── Backgrounds ───────────────────────────────────────────────────────────────
const Color backgroundDark    = Color(0xFF0F1C24); // Quran reading / Tasbih
const Color surfaceDark       = Color(0xFF1A2C38); // Dark cards
const Color backgroundLight   = Color(0xFFF7F3EE); // Home / lists (warm off-white)
const Color surfaceColor      = Color(0xFFFFFFFF); // Light cards

// ─── Text ──────────────────────────────────────────────────────────────────────
const Color textPrimary       = Color(0xFF1A1A2E);
const Color textSecondary     = Color(0xFF6B8FA8);
const Color textDisabled      = Color(0xFFA7BEC5);

// ─── Semantic / Status ─────────────────────────────────────────────────────────
const Color successColor      = Color(0xFF4CAF7D);
const Color warningColor      = Color(0xFFE6A817);
const Color errorColor        = Color(0xFFC94040);
const Color infoColor         = Color(0xFF4A90B8);

// ─── Misc ──────────────────────────────────────────────────────────────────────
const Color dividerColor      = Color(0xFFD4CFC9);
const Color ayahHighlight     = Color(0xFFE8F4EA);
const Color lastReadingColor  = Color(0xFFF5F0E6);

// ─── Feature-card tints (all derive from warm off-white + teal) ───────────────
const Color azkarColor        = Color(0xFFE8F6F3);  // light mint
const Color quranColor        = Color(0xFFE6F3FF);  // light sky
const Color qiblaColor        = Color(0xFFEAF0FF);  // light periwinkle (alias: tasbih)
const Color favoritesColor    = Color(0xFFFFF8E6);  // warm yellow-cream

// ─── Context-sensitive helpers ─────────────────────────────────────────────────
Color backgroundColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? backgroundDark
      : backgroundLight;
}

Color colorQuranPages(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? backgroundLight
      : backgroundDark;
}

// Active prayer highlight (teal at ~15 % opacity painted on white)
const Color activePrayerHighlight = Color(0xFFB7E4DB);
