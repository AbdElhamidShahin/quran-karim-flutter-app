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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => QuranDetailsScreen(
                  surahNumber: sura.surahNumber,
                  surahName: sura.surahNameAr,
                  surahNameEn: sura.surahNameEn,
                  transliteration: sura.surahTransliteration,
                  pageNumber: sura.page,
                ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: primaryLight.withOpacity(0.4), // أخضر فاتح ومريح
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                sura.surahNumber.toString(),
                style: TextStyle(
                  color: primaryDark, // أخضر غامق واضح للرقم
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sura.surahNameAr,
                    style: surahNameArStyle().copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'عدد الآيات: ${SurahAyahCounts[sura.surahNumber] ?? 'غير معروف'}',
                    style: TextStyle(fontSize: 13, color: textSecondary),
                  ),
                ],
              ),
            ),

            Text(
              sura.surahTransliteration,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
