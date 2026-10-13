import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../QuranDetailsScreen.dart';

class LastReadWidget extends StatefulWidget {
  const LastReadWidget({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  State<LastReadWidget> createState() => _LastReadWidgetState();
}

class _LastReadWidgetState extends State<LastReadWidget> {
  int _lastPage = 1;
  int _lastSurah = 1;
  String _lastSurahName = 'الفاتحة';
  bool _hasRead = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastPage      = prefs.getInt('last_read_page')        ?? 1;
      _lastSurah     = prefs.getInt('last_read_surah')       ?? 1;
      _lastSurahName = prefs.getString('last_read_surah_name') ?? 'الفاتحة';
      _hasRead       = prefs.containsKey('last_read_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuranDetailsScreen(
            pageNumber: _lastPage,
            surahNumber: _lastSurah,
            surahName: _lastSurahName,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1A3040), const Color(0xFF0F2030)]
                : [const Color(0xFFFFF8EC), const Color(0xFFEDF7F4)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Decorative lantern icon ──────────────────────────────────
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.menu_book_rounded,
                  color: accentColor, size: 28),
            ),
            const SizedBox(width: 14),
            // ── Text info ────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'آخر قراءة',
                    style: sectionHeaderStyle().copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _hasRead
                        ? 'سورة $_lastSurahName  •  صفحة $_lastPage'
                        : 'ابدأ القراءة من الصفحة الأولى',
                    style: tafsirTextStyle().copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // ── Arrow cue ────────────────────────────────────────────────
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: primaryColor,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
