import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../veiw/screens/AzkarDetailsPage.dart' show AzkarDetailsPage;
import '../../veiw/wedgit/CustomAzkarPage.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../suraMap.dart';
import 'ItemAzkatr.dart';
import 'azkarJsonScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> results = [];
  String query = "";
  void search(String query) async {
    var resultsList = await ItemService.searchExercises(query);
    results = resultsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 16,),
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
                textDirection:
                    TextDirection.rtl, // تحديد اتجاه الكتابة من اليمين لليسار
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-Z0-9\u0600-\u06FF\s]'),
                  ),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '      ابحث عن الاذكار     ',
                  hintStyle: selectedAyahStyle(),

                  prefixIcon: const Icon(Icons.search, color: primaryDark),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 40, // يمكنك تعديل الحجم حسب الحاجة
                  ),
                ),
                textAlign: TextAlign.right,
              ),
            ),

            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final azkar = results[index];
                  final categoryName = azkar['category'] ?? 'no name';

                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,

                        child: GestureDetector(
                          onTap: () {
                            final azkarCategory = AzkarCategoryModel.fromJson(
                              azkar,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        AzkarDetailsPage(azkar: azkarCategory),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              textDirection: TextDirection.rtl,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Text(
                                        categoryName,
                                        style: sajdaMarkerStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    getCategoryIcon(categoryName),
                                    color: primaryColor,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemService {
  static Future<List<Map<String, dynamic>>> searchExercises(
    String query,
  ) async {
    final List<AzkarCategoryModel> allAzkar =
        await fetchAzkarCategoryFromJson();

    final List<Map<String, dynamic>> results =
        allAzkar
            .where(
              (azkar) =>
                  azkar.category.toLowerCase().contains(query.toLowerCase()),
            )
            .map((azkar) => azkar.toJson())
            .toList();

    return results;
  }
}
