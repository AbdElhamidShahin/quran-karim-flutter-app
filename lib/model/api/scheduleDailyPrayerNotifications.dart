import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'NotificationService.dart';
import 'apiServise.dart';
import '../../veiw_model/helper/Position/getPosition.dart';

@pragma('vm:entry-point')
Future<void> scheduleDailyPrayerNotifications() async {
  try {
    tz.initializeTimeZones();
    final position = await getPosition();
    final service = PrayerService();
    final prayerTimes = await service.fetchPrayerTimes(
        position.latitude,
        position.longitude
    );
    final now = tz.TZDateTime.now(tz.local);

    for (var entry in prayerTimes.entries) {
      final name = entry.key;
      final timeParts = entry.value.split(':');
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);

      if (hour == null || minute == null) continue;

      var scheduleTime = tz.TZDateTime.local(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      print('''
⏰ مواعيد الإشعارات التجريبية:
الفجر: ${prayerTimes['الفجر']}
الظهر: ${prayerTimes['الظهر']}
العصر: ${prayerTimes['العصر']}
المغرب: ${prayerTimes['المغرب']}
العشاء: ${prayerTimes['العشاء']}
''');
      // إذا كان وقت الصلاة قد مضى اليوم، نضيف يومًا
      if (scheduleTime.isBefore(now)) {
        scheduleTime = scheduleTime.add(const Duration(days: 1));
      }

      await NotificationService.showScheduledNotification(
        prayerName: name,
        time: entry.value,
        scheduledTime: scheduleTime,
      );
    }
  } catch (e) {
    print("❌ Error in scheduleDailyPrayerNotifications: $e");
  }
}