import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';

Widget buildPrayerTimesUI(
    Map<String, String> times,
    String nextPrayerName,
    Duration remainingTime,
    bool isAdhanPlaying,
    ) {
  // دالة لتحويل الوقت من 24 ساعة إلى 12 ساعة
  String _formatTimeTo12Hour(String time24) {
    try {
      final timeParts = time24.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts[1];

      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '$hour12:$minute $period';
    } catch (e) {
      debugPrint('Error converting to 12-hour format: $e');
      return time24;
    }
  }
  final orderedPrayers = [
    {'name': 'الفجر', 'time': times['الفجر'] ?? '--:--'},
    {'name': 'الظهر', 'time': times['الظهر'] ?? '--:--'},
    {'name': 'العصر', 'time': times['العصر'] ?? '--:--'},
    {'name': 'المغرب', 'time': times['المغرب'] ?? '--:--'},
    {'name': 'العشاء', 'time': times['العشاء'] ?? '--:--'},
  ];

  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  isAdhanPlaying ? 'الأذان الآن' : 'الوقت الحالي',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('hh:mm a').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isAdhanPlaying
                      ? 'صلاة $nextPrayerName'
                      : 'متبقي حتى صلاة $nextPrayerName',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  isAdhanPlaying
                      ? 'حان وقت الصلاة'
                      : 'الوقت المتبقي: ${remainingTime.inHours.remainder(24).toString().padLeft(2, '0')}:${(remainingTime.inMinutes.remainder(60)).toString().padLeft(2, '0')}:${(remainingTime.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: orderedPrayers.length,
            itemBuilder: (context, index) {
              final prayer = orderedPrayers[index];
              final isCurrent = isAdhanPlaying && nextPrayerName == prayer['name'];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isCurrent ? Colors.teal[100] : ayahHighlight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: isCurrent
                      ? const Icon(Icons.volume_up, color: Colors.teal)
                      : null,
                  title: Text(
                    _formatTimeTo12Hour(prayer['time']!),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                      color: primaryDark
                    ),
                  ),
                  trailing: Text(
                    prayer['name']!,
                    style: surahNumberCircleStyle().copyWith(
                      color: primaryDark
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}