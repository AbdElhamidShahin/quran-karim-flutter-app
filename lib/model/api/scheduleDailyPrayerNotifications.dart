import 'package:timezone/timezone.dart' as tz;
import '../../veiw_model/helper/Position/getPosition.dart' show getPosition;
import 'NotificationService.dart';
import 'apiServise.dart';
int fixHour(String prayerName, int hour) {
  if (prayerName == 'الفجر') return hour;
  return hour < 12 ? hour + 12 : hour;
}
Future<void> scheduleDailyPrayerNotifications() async {
  try {
    final position = await getPosition();
    final service = PrayerService();
    final prayerTimes = await service.fetchPrayerTimes(
      position.latitude,
      position.longitude,
    );

    final now = tz.TZDateTime.now(tz.local);

    print("🕌 أوقات الصلاة اليوم:");
    prayerTimes.forEach((key, value) => print("👉 $key: $value"));

    for (var entry in prayerTimes.entries) {
      final name = entry.key;
      final cleanTime = entry.value.trim().split(' ').first;
      final timeParts = cleanTime.split(':');
      int? rawHour = int.tryParse(timeParts[0]);
      int? minute = int.tryParse(timeParts[1]);

      if (rawHour == null || minute == null) continue;

      final hour = fixHour(name, rawHour);

      final scheduleTime = tz.TZDateTime.local(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      ).subtract(Duration(minutes: 5));

      final diff = scheduleTime.difference(now).inMinutes;

      print("🔔 [$name] الوقت المجدول: $scheduleTime | الفرق بالدقائق: $diff");

      if (scheduleTime.isAfter(now)) {
        await NotificationService.showScheduledNotification(
          prayerName: name,
          time: cleanTime,
          scheduledTime: scheduleTime,
        );
      } else {
        print("⏩ تخطي $name لأنه عدّى عليه أكتر من دقيقة");
      }
    }

    print("✅ إشعارات الصلوات تم جدولتها بنجاح");
  } catch (e) {
    print("❌ خطأ في scheduleDailyPrayerNotifications: $e");
  }
}
