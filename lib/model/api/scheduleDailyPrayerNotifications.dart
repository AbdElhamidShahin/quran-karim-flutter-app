import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'NotificationService.dart';
import 'apiServise.dart';
import '../../veiw_model/helper/Position/getPosition.dart';

@pragma('vm:entry-point') // ⬅️ هام جدًا
Future<void> scheduleDailyPrayerNotifications() async {
  try {
    tz.initializeTimeZones(); // ⬅️ لازم هنا كمان
    final position = await getPosition();
    final service = PrayerService();
    final prayerTimes = await service.fetchPrayerTimes(position.latitude, position.longitude);
    final now = tz.TZDateTime.now(tz.local);

    for (var entry in prayerTimes.entries) {
      final name = entry.key;
      final timeParts = entry.value.split(':');
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) continue;

      final scheduleTime = tz.TZDateTime.local(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      ).subtract(const Duration(seconds: 20));

      if (scheduleTime.isAfter(now)) {
        await NotificationService.showScheduledNotification(
          prayerName: name,
          time: entry.value,
          scheduledTime: scheduleTime,
        );
      }
    }

    print("📌 تم تنفيذ scheduleDailyPrayerNotifications");
    print("✅ إشعارات الصلوات تم جدولتها بنجاح");
  } catch (e) {
    print("❌ Error in scheduleDailyPrayerNotifications: $e");
  }
}
