import 'package:flutter/material.dart';
import '../../model/azkarModel/AzkarCategoryModel.dart';
import '../../model/azkarModel/ItemAzkatr.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../screens/AzkarDetailsPage.dart';

class CustomAzkarPage extends StatelessWidget {
  const CustomAzkarPage({super.key, required this.azkarCategory});

  final AzkarCategoryModel azkarCategory;

  @override
  Widget build(BuildContext context) {
    return
      Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AzkarDetailsPage(azkar: azkarCategory),
                  ),
                ),
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
                        Text(azkarCategory.category, style: sajdaMarkerStyle()),
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
                      getCategoryIcon(azkarCategory.category),
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
  }
}

IconData getCategoryIcon(String category) {
  final iconMap = {
    'الصباح': Icons.wb_sunny,
    'المساء': Icons.nights_stay,
    'الوضوء': Icons.water_drop,
    'الخلاء': Icons.wc,
    'النوم': Icons.bedtime_outlined,
    'الأكل': Icons.restaurant_outlined,
    'المسجد': Icons.mosque_outlined,
  };

  return iconMap.entries
      .firstWhere(
        (entry) => category.contains(entry.key),
        orElse: () => const MapEntry('', Icons.auto_stories),
      )
      .value;
}
