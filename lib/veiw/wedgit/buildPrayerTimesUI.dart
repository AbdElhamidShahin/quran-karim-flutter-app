import 'package:flutter/material.dart';
import '../../veiw_model/helper/prayerData.dart';
import '../../veiw_model/helper/thems/color.dart';

Widget buildPrayerTimesUI(
  Map<String, String> times,
  String nextPrayerName,
  Duration remainingTime,
  BuildContext context,
  String cityName,
) {
  final orderedPrayers = [
    {'name': 'الفجر', 'time': times['الفجر'] ?? '--:--'},
    {'name': 'الظهر', 'time': times['الظهر'] ?? '--:--'},
    {'name': 'العصر', 'time': times['العصر'] ?? '--:--'},
    {'name': 'المغرب', 'time': times['المغرب'] ?? '--:--'},
    {'name': 'العشاء', 'time': times['العشاء'] ?? '--:--'},
  ];

  return Column(
    children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.height * 0.8,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(
              prayerData[nextPrayerName]!['image'], // صورة الصلاة
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(0.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'الصلاة التالية: $nextPrayerName',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'متبقي: ${remainingTime.inHours.remainder(24).toString().padLeft(2, '0')}:${remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),

      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const Expanded(
              child: Divider(color: Colors.grey, thickness: 1, endIndent: 10),
            ),
            Text(
              'المدينة: $cityName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Expanded(
              child: Divider(color: Colors.grey, thickness: 1, indent: 10),
            ),
          ],
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.02),

      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: orderedPrayers.length,
          itemBuilder: (context, index) {
            final prayer = orderedPrayers[index];
            final isCurrent = nextPrayerName == prayer['name'];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isCurrent ? Colors.teal[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  prayerData[prayer['name']]!['icon'],
                  color: isCurrent ? Colors.teal : Colors.grey,
                ),

                title: Text(
                  prayer['name']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: primaryDark,
                  ),
                ),
                trailing: Text(
                  getFormattedTime(prayer['time']!),
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryDark,
                    fontWeight: FontWeight.w600,
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
