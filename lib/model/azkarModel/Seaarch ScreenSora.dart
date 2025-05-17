import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_app/model/item.dart';
import '../../veiw/QuranDetailsScreen.dart';
import '../../veiw/wedgit/CustomQuranPage.dart';
import '../../veiw_model/helper/surahAyahCounts.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../JsonScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Item> results = [];
  String query = "";

  void search(String query) async {
    var resultsList = await ItemService.searchSyra(query);
    setState(() {
      results = resultsList;
    });
  }

  IconData getCategoryIcon(String surahName) {
    // يمكنك إضافة منطق خاص بك هنا لاختيار الأيقونة المناسبة
    return Icons.menu_book;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  query = text;
                });
                search(query);
              },
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp('[a-zA-Z0-9\u0600-\u06FF\s]'),
                ),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'ابحث عن السوره',
                hintStyle: selectedAyahStyle(),
                prefixIcon: const Icon(Icons.search, color: primaryDark),
                prefixIconConstraints: BoxConstraints(minWidth: 40),
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: results.isEmpty && query.isNotEmpty
                ? Center(
                    child: Text(
                      'لا توجد نتائج',
                      style: selectedAyahStyle(),
                    ),
                  )
                : AnimationLimiter(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.all(16),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        final surahName = item.surahNameAr;
                        final surahTransliteration =
                            item.surahTransliteration;
                        final surahNumber = item.surahNumber;

                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 1000),
                            child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.05),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    QuranDetailsScreen(
                                                  surahNumber:
                                                      item.surahNumber,
                                                  surahName: item.surahNameAr,
                                                  surahNameEn:
                                                      item.surahNameEn,
                                                  transliteration: item
                                                      .surahTransliteration,
                                                  pageNumber: item.page,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 12),
                                            margin:
                                                const EdgeInsets.symmetric(
                                                    vertical: 6),
                                            decoration: BoxDecoration(
                                              color: surfaceColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.03),
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
                                                    color: primaryLight
                                                        .withOpacity(
                                                            0.4), // أخضر فاتح ومريح
                                                    shape: BoxShape.circle,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    surahNumber.toString(),
                                                    style: TextStyle(
                                                      color:
                                                          primaryDark, // أخضر غامق واضح للرقم
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        surahName,
                                                        style:
                                                            surahNameArStyle()
                                                                .copyWith(
                                                                    fontSize:
                                                                        22),
                                                      ),
                                                      const SizedBox(
                                                          height: 4),
                                                      Text(
                                                        'عدد الآيات: ${SurahAyahCounts[surahNumber] ?? 'غير معروف'}',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                textSecondary),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  surahTransliteration,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )));
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

class ItemService {
  static Future<List<Item>> searchSyra(String query) async {
    final List<Item> allSura = (await fetchSuraDetails());

    final List<Item> results = allSura
        .where(
          (sura) =>
              sura.surahNameAr.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return results;
  }
}
