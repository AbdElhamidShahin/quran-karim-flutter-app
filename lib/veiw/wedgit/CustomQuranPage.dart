import 'package:flutter/material.dart';
import '../../model/item.dart';
import '../../veiw_model/helper/surahAyahCounts.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../QuranDetailsScreen.dart';

class CustomQuranPage extends StatelessWidget {
  final int index;
  final Item sura;

  const CustomQuranPage({super.key, required this.index, required this.sura});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuranDetailsScreen(
            surahNumber:    sura.surahNumber,
            surahName:      sura.surahNameAr,
            surahNameEn:    sura.surahNameEn,
            transliteration: sura.surahTransliteration,
            pageNumber:     sura.page,
          ),
        ),
      ),
      child: Container(
        // Reduced vertical padding → more rows visible on screen
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? surfaceDark : surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: primaryColor.withOpacity(0.10),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Surah number badge ───────────────────────────────────────
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${sura.surahNumber}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Arabic name + verse count ────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sura.surahNameAr,
                    style: surahNameArStyle().copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'عدد الآيات: ${SurahAyahCounts[sura.surahNumber] ?? '-'}',
                    style: ayahCountStyle(),
                  ),
                ],
              ),
            ),

            // ── Transliteration ─────────────────────────────────────────
            Text(
              sura.surahTransliteration,
              style: surahNameEnStyle().copyWith(
                fontSize: 13,
                color: isDark ? primaryLight : textSecondary,
              ),
            ),

            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: primaryColor.withOpacity(0.4),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
