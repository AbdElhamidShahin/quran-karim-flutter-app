import 'package:flutter/material.dart';
import '../../model/azkarModel/ItemAzkatr.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../wedgit/CustomAppBar.dart';

class AzkarDetailsPage extends StatelessWidget {
  final AzkarCategoryModel azkar;

  const AzkarDetailsPage({Key? key, required this.azkar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: (azkar.category)),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: azkar.array.length,
          itemBuilder: (context, index) {
            final item = azkar.array[index];
            return Padding(
              padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: surfaceColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.text,
                        style: selectedAyahStyle(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: continar,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 8, bottom: 8),
                          child: Text(
                            "عدد التكرار: ${item.count}",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
