import 'package:flutter/material.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';

/// Feature card on the Home screen.
/// Uses a consistent white/light surface regardless of which feature it shows.
class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    required this.height1,
    required this.image,
    required this.title,
    required this.color,
    required this.onpressed,
  }) : super(key: key);

  final double height1;
  final String image;
  final String title;
  final VoidCallback? onpressed;
  final Color color; // kept for caller compatibility but used subtly

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(top: width * .04),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          height: height1,
          width: width * .42,
          decoration: BoxDecoration(
            color: isDark ? surfaceDark : surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(isDark ? 0.15 : 0.10),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            // Subtle left border accent in the card's feature color
            border: Border(
              right: BorderSide(color: primaryColor.withOpacity(0.35), width: 3),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: width * .04,
              horizontal: width * .035,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Feature icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(image, fit: BoxFit.contain),
                  ),
                ),
                const Spacer(),
                Text(title, style: sectionHeaderStyle()),
                const SizedBox(height: 4),
                // Subtle "tap" cue — just a small arrow, no text
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: primaryColor.withOpacity(0.6),
                  size: 13,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
