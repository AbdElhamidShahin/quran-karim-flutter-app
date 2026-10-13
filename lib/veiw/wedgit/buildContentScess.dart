import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/item.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';

// ─── Font-size persistence key ────────────────────────────────────────────────
const String _kFontSizeKey = 'quran_reader_font_scale';

Widget buildContentSuccess(
  BuildContext context,
  List<Item> pages,
  String surahName, {
  required PageController pageController,
  required Function(int) onPageChanged,
  String? surahNameEn,
  String? transliteration,
}) {
  return _QuranReaderView(
    pages: pages,
    surahName: surahName,
    pageController: pageController,
    onPageChanged: onPageChanged,
  );
}

class _QuranReaderView extends StatefulWidget {
  final List<Item> pages;
  final String surahName;
  final PageController pageController;
  final Function(int) onPageChanged;

  const _QuranReaderView({
    required this.pages,
    required this.surahName,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  State<_QuranReaderView> createState() => _QuranReaderViewState();
}

class _QuranReaderViewState extends State<_QuranReaderView> {
  double _fontScale  = 1.0; // 0.8 | 1.0 | 1.2 | 1.4
  bool   _showToolbar = true;
  int    _currentIndex = 0;

  static const List<double> _scales = [0.8, 1.0, 1.2, 1.4];
  static const List<String> _scaleLabels = ['صغير', 'عادي', 'كبير', 'أكبر'];

  @override
  void initState() {
    super.initState();
    _loadFontScale();
    // Sync current index from the PageController's initial page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.pageController.hasClients) {
        setState(() {
          _currentIndex =
              widget.pageController.initialPage.clamp(0, widget.pages.length - 1);
        });
      }
    });
  }

  Future<void> _loadFontScale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble(_kFontSizeKey) ?? 1.0;
    if (mounted) setState(() => _fontScale = saved);
  }

  Future<void> _saveFontScale(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kFontSizeKey, scale);
  }

  void _cycleFontSize() {
    final idx     = _scales.indexOf(_fontScale);
    final nextIdx = (idx + 1) % _scales.length;
    final next    = _scales[nextIdx];
    setState(() => _fontScale = next);
    _saveFontScale(next);
    final label = _scaleLabels[nextIdx];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('حجم الخط: $label',
            style: const TextStyle(fontFamily: 'Cairo')),
        duration: const Duration(seconds: 1),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _goToPage(int delta) {
    final target = _currentIndex + delta;
    if (target < 0 || target >= widget.pages.length) return;
    widget.pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _currentIndex < widget.pages.length
        ? widget.pages[_currentIndex]
        : widget.pages.first;

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'سورة ${widget.surahName}',
          style: const TextStyle(
            fontFamily: 'Lalezar',
            fontSize: 22,
            color: primaryColor,
            letterSpacing: 0.5,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${page.page}',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: primaryLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        actions: [
          // Font-size cycle button
          IconButton(
            icon: const Icon(Icons.text_fields_rounded, color: primaryLight),
            tooltip: 'حجم الخط',
            onPressed: _cycleFontSize,
          ),
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: primaryLight),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Page viewer ──────────────────────────────────────────────────
          PageView.builder(
            controller: widget.pageController,
            itemCount: widget.pages.length,
            reverse: true, // Arabic RTL: swipe left to go forward
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              widget.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              final p = widget.pages[index];
              return GestureDetector(
                onTap: () =>
                    setState(() => _showToolbar = !_showToolbar),
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 3.0,
                    child: Image.asset(
                      p.imageUrl,
                      color: colorQuranPages(context),
                      colorBlendMode: BlendMode.modulate,
                      width: MediaQuery.of(context).size.width * 0.97 * _fontScale,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        color: surfaceDark,
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: primaryLight, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Bottom navigation toolbar ────────────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            bottom: _showToolbar ? 0 : -80,
            left: 0,
            right: 0,
            child: _PageNavBar(
              currentIndex: _currentIndex,
              total: widget.pages.length,
              onPrev: () => _goToPage(1),  // reverse: true, so +1 = previous
              onNext: () => _goToPage(-1), // -1 = next page
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom bar with previous/next page arrows and page progress
class _PageNavBar extends StatelessWidget {
  final int currentIndex;
  final int total;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _PageNavBar({
    required this.currentIndex,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final canGoNext = currentIndex > 0;
    final canGoPrev = currentIndex < total - 1;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: surfaceDark,
        border: Border(top: BorderSide(color: primaryColor.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Next page (lower index in reversed list = further in Quran)
          _NavButton(
            icon: Icons.chevron_right_rounded,
            label: 'التالية',
            enabled: canGoNext,
            onTap: onNext,
          ),

          // Page indicator
          Text(
            '${currentIndex + 1} / $total',
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: primaryLight,
              fontSize: 14,
            ),
          ),

          // Previous page
          _NavButton(
            icon: Icons.chevron_left_rounded,
            label: 'السابقة',
            enabled: canGoPrev,
            onTap: onPrev,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon,
                color: enabled
                    ? primaryColor
                    : primaryColor.withOpacity(0.3),
                size: 28),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: enabled
                    ? primaryLight
                    : primaryLight.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
