import 'package:flutter/material.dart';
import '../../model/item.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';

Widget buildContentSuccess(
  BuildContext context,
  List<Item> pages,
  String surahName, {
  required PageController pageController,
  required Function(int) onPageChanged,
  String? surahNameEn,
  String? transliteration,
}) {
  return PageView.builder(
    controller: pageController,
    onPageChanged: onPageChanged,
    itemCount: pages.length,
    reverse: true,

    itemBuilder: (context, index) {
      final page = pages[index];
      return Scaffold(
        appBar: AppBar(
          actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          backgroundColor: backgroundColor(context),
          title: Column(
            children: [Text("سوره $surahName", style: appBarTitleStyle())],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_forward_outlined),
            ),
          ],
          leading: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text("${page.page}", style: appBodyStyle()),
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 32),
            Image.asset(
              color: colorQuranPages(context),
              page.imageUrl,
              width: MediaQuery.of(context).size.width*.99,

              errorBuilder:
                  (ctx, err, _) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  ),
            ),
          ],
        ),
      );
    },
  );
}
