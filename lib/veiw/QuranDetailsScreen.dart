import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/item.dart';
import '../model/JsonScreen.dart';
import 'wedgit/buildLoadingShimmer.dart';
import 'wedgit/buildEmptyWidget.dart';
import 'wedgit/buildContentScess.dart';
import 'wedgit/buildErrorWidget.dart';

class QuranDetailsScreen extends StatefulWidget {
  final int surahNumber;
  final int pageNumber;
  final String surahName;
  final String? surahNameEn;
  final String? transliteration;
  List<Item>? pages;

  QuranDetailsScreen({
    super.key,
    required this.pageNumber,
    required this.surahNumber,
    required this.surahName,
    this.surahNameEn,
    this.transliteration,
    this.pages,
  });

  @override
  State<QuranDetailsScreen> createState() => _QuranDetailsScreenState();
}

class _QuranDetailsScreenState extends State<QuranDetailsScreen> {
  late Future<List<Item>> _pagesFuture;
  PageController? _pageController;
  int _initialIndex = 0;

  @override
  void initState() {
    super.initState();
    _pagesFuture =
        fetchQuranPagesBySurah(widget.surahNumber) ?? Future.value([]);
  }

  Future<void> _saveLastReadPage(int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_read_page', pageNumber);
    await prefs.setInt('last_read_surah', widget.surahNumber);
    await prefs.setString('last_read_surah_name', widget.surahName);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: _pagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingShimmer();
        }
        if (snapshot.hasError) {
          return buildErrorWidget('خطأ في تحميل الصفحات');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildEmptyWidget();
        }

        final pages = snapshot.data!;

        // Initialise the controller once after data is available
        if (_pageController == null) {
          final pageIndex =
              pages.indexWhere((p) => p.page == widget.pageNumber);
          _initialIndex = pageIndex != -1 ? pageIndex : 0;
          _pageController = PageController(initialPage: _initialIndex);
        }

        return buildContentSuccess(
          context,
          pages,
          widget.surahName,
          pageController: _pageController!,
          onPageChanged: (index) {
            if (index < pages.length) {
              _saveLastReadPage(pages[index].page);
            }
          },
          surahNameEn: widget.surahNameEn,
          transliteration: widget.transliteration,
        );
      },
    );
  }
}
