import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../veiw/QuranDetailsScreen.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../Item.dart';
import '../JsonScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Item> results = [];
  String query = "";

  @override
  void initState() {
    super.initState();
    // عرض كل السور عند الفتح
    search("");
  }

  void search(String query) async {
    final resultsList = await ItemService.searchSyra(query);
    setState(() {
      results = resultsList;
    });
  }

  IconData getCategoryIcon(String surahName) {
    return Icons.menu_book;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // شريط البحث
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5)],
              ),
              child: TextField(
                onChanged: (text) {
                  query = text;
                  search(query);
                },
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9\u0600-\u06FF\s]')),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'ابحث عن السوره',
                  hintStyle: selectedAyahStyle(),
                  prefixIcon: const Icon(Icons.search, color: primaryDark),
                  prefixIconConstraints: const BoxConstraints(minWidth: 40),
                ),
                textAlign: TextAlign.right,
              ),
            ),

            // قائمة النتائج أو رسالة "لا توجد نتائج"
            Expanded(
              child: results.isEmpty && query.isNotEmpty
                  ? Center(child: Text('لا توجد نتائج', style: selectedAyahStyle()))
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  return _buildSurahCard(context, item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahCard(BuildContext context, Item item) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuranDetailsScreen(
                    surahNumber: item.surahNumber,
                    surahName: item.surahNameAr,
                    surahNameEn: item.surahNameEn,
                    transliteration: item.surahTransliteration,
                    pageNumber: item.page,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(item.surahNameAr, style: sajdaMarkerStyle()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(getCategoryIcon(item.surahNameAr), color: primaryColor, size: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemService {
  static Future<List<Item>> searchSyra(String query) async {
    final List<Item> allSura = await fetchSuraDetails();

    if (query.trim().isEmpty) return allSura;

    return allSura
        .where((sura) => sura.surahNameAr.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}