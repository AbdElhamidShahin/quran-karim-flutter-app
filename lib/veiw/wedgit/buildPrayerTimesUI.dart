import 'package:flutter/material.dart';
import '../../veiw_model/helper/prayerData.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';

Widget buildPrayerTimesUI(
  Map<String, String> times,
  String nextPrayerName,
  Duration remainingTime,
  BuildContext context,
  String cityName,
) {
  final orderedPrayers = [
    {'name': 'الفجر',   'time': times['الفجر']   ?? '--:--'},
    {'name': 'الظهر',   'time': times['الظهر']   ?? '--:--'},
    {'name': 'العصر',   'time': times['العصر']   ?? '--:--'},
    {'name': 'المغرب',  'time': times['المغرب']  ?? '--:--'},
    {'name': 'العشاء',  'time': times['العشاء']  ?? '--:--'},
  ];

  final screenHeight = MediaQuery.of(context).size.height;

  // Fallback to Fajr image if nextPrayerName is not yet known
  final heroImage = (prayerData[nextPrayerName]?['image'] as String?) ??
      'assets/Images sala/1.jpg';

  final hh = remainingTime.inHours.remainder(24).toString().padLeft(2, '0');
  final mm = remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
  final ss = remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');

  return Column(
    children: [
      // ── Hero image card ────────────────────────────────────────────────
      Container(
        height: screenHeight * 0.22,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(heroImage),
            fit: BoxFit.cover,
            // Darken the image so text is always readable
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.45),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // Extra gradient at the bottom for text legibility
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.55),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                nextPrayerName.isNotEmpty
                    ? 'الصلاة التالية: $nextPrayerName'
                    : 'جار التحميل...',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 6),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined,
                      color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    // Clear label: "الوقت المتبقي" instead of bare "متبقي:"
                    'الوقت المتبقي: $hh:$mm:$ss',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // ── City divider ───────────────────────────────────────────────────
      Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            const Expanded(
                child: Divider(color: dividerColor, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: primaryColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    cityName,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
                child: Divider(color: dividerColor, thickness: 1)),
          ],
        ),
      ),

      // ── Prayer rows ────────────────────────────────────────────────────
      Expanded(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: orderedPrayers.length,
          itemBuilder: (context, index) {
            final prayer    = orderedPrayers[index];
            final isCurrent = nextPrayerName == prayer['name'];
            final icon      = prayerData[prayer['name']]?['icon'] as IconData?
                ?? Icons.access_time_rounded;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: isCurrent ? activePrayerHighlight : surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: isCurrent
                    ? Border.all(color: primaryColor, width: 1.5)
                    : Border.all(
                        color: dividerColor.withOpacity(0.6), width: 1),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? primaryColor
                        : primaryColor.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isCurrent ? Colors.white : primaryColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  prayer['name']!,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 17,
                    fontWeight:
                        isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent ? primaryDark : textPrimary,
                  ),
                ),
                trailing: Text(
                  getFormattedTime(prayer['time']!),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    color: isCurrent ? primaryColor : textSecondary,
                    fontWeight:
                        isCurrent ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
