import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/azkarModel/AzkarCategoryModel.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../wedgit/CustomAppBar.dart';

class AzkarDetailsPage extends StatelessWidget {
  final AzkarCategoryModel azkar;

  const AzkarDetailsPage({Key? key, required this.azkar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: azkar.category),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: azkar.array.length,
          itemBuilder: (context, index) {
            final item = azkar.array[index];
            return _AzkarCard(
              index: index + 1,
              text: item.text,
              count: item.count,
            );
          },
        ),
      ),
    );
  }
}

class _AzkarCard extends StatelessWidget {
  final int index;
  final String text;
  final String count;

  const _AzkarCard({
    required this.index,
    required this.text,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        color: isDark ? surfaceDark : surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header bar ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dhikr index badge
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                // Share button
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم نسخ الذكر',
                            style: TextStyle(fontFamily: 'Cairo')),
                        duration: Duration(seconds: 2),
                        backgroundColor: primaryColor,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.copy_outlined,
                        color: primaryColor.withOpacity(0.7), size: 18),
                  ),
                ),
              ],
            ),
          ),

          // ── Dhikr text ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                // 2.0 line height prevents diacritic collisions on vocalized text
                height: 2.0,
                color: isDark ? Colors.white.withOpacity(0.9) : textPrimary,
                letterSpacing: 0.3,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),

          // ── Repetition badge ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    // Solid brand teal for maximum contrast (white text on top)
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.repeat_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'عدد التكرار: $count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
