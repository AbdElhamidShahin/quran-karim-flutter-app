import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';

class CustomSearchscreen extends StatelessWidget {
  const CustomSearchscreen({
    super.key,
    required this.text,
    required this.ontap,
  });

  final String text;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark ? surfaceDark : surfaceColor,
        border: Border.all(
          color: primaryColor.withOpacity(0.20),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        textDirection: TextDirection.rtl,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp('[a-zA-Z0-9\u0600-\u06FF\\s]'),
          ),
        ],
        style: appBodyStyle().copyWith(
          fontSize: 15,
          color: isDark ? Colors.white.withOpacity(0.9) : textPrimary,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          hintText: text,
          hintStyle: appBodyStyle().copyWith(
            fontSize: 15,
            color: textDisabled,
          ),
          prefixIcon:
              Icon(Icons.search_rounded, color: primaryColor, size: 22),
        ),
        textAlign: TextAlign.right,
        onTap: ontap,
      ),
    );
  }
}
