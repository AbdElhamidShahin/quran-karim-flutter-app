import 'package:flutter/material.dart';
import '../../model/azkarModel/AzkarCategoryModel.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../screens/AzkarDetailsPage.dart';

class CustomAzkarPage extends StatelessWidget {
  const CustomAzkarPage({super.key, required this.azkarCategory});

  final AzkarCategoryModel azkarCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final icon   = getCategoryIcon(azkarCategory.category);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: isDark ? surfaceDark : surfaceColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AzkarDetailsPage(azkar: azkarCategory),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: primaryColor.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Icon in a teal circle
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: primaryColor, size: 22),
                  ),
                  const SizedBox(width: 10),
                  // Category name — left-aligned, no wrapping issues
                  Expanded(
                    child: Text(
                      azkarCategory.category,
                      style: sajdaMarkerStyle().copyWith(fontSize: 14),
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
    'الصباح':   Icons.wb_sunny_outlined,
    'المساء':   Icons.nights_stay_outlined,
    'الوضوء':   Icons.water_drop_outlined,
    'الخلاء':   Icons.wc,
    'النوم':    Icons.bedtime_outlined,
    'الأكل':    Icons.restaurant_outlined,
    'المسجد':   Icons.mosque_outlined,
    'الاستيقاظ': Icons.alarm_outlined,
    'السفر':    Icons.flight_outlined,
    'المطر':    Icons.water_outlined,
  };

  return iconMap.entries
      .firstWhere(
        (e) => category.contains(e.key),
        orElse: () => const MapEntry('', Icons.auto_stories_outlined),
      )
      .value;
}
