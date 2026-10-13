import 'package:flutter/material.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';

Widget buildErrorWidget(String error, {VoidCallback? onRetry}) {
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
              color: errorColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wifi_off_rounded,
                size: 38, color: errorColor),
          ),
          const SizedBox(height: 20),
          Text(
            'تعذّر تحميل البيانات',
            style: sectionHeaderStyle().copyWith(color: errorColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: appBodyStyle().copyWith(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('حاول مرة أخرى',
                  style: TextStyle(fontFamily: 'Cairo')),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
