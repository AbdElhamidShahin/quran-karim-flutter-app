import 'package:flutter/material.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';

Widget buildEmptyWidget() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.menu_book_rounded,
                size: 38, color: primaryColor),
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد صفحات متاحة',
            style: sectionHeaderStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'لم يُعثر على صفحات هذه السورة.\nتحقق من ملفات التطبيق.',
            textAlign: TextAlign.center,
            style: appBodyStyle().copyWith(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}
