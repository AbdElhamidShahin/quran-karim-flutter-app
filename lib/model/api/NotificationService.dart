import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'prayer_channel_id',
      'مواعيد الصلاة',
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  } static Future<void> schedulePrayerNotifications(
      Map<String, String> prayerTimes) async {
    await _notificationsPlugin.cancelAll();
    final now = tz.TZDateTime.now(tz.local);

    for (final entry in prayerTimes.entries) {
      final prayerName = entry.key;
      final timeParts = entry.value.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // جدولة إشعار اليوم
      _scheduleSingleNotification(prayerName, hour, minute, now);

      // جدولة إشعار الغد للتكرار التلقائي
      _scheduleSingleNotification(
          prayerName, hour, minute, now.add(const Duration(days: 1)));
    }
  }
  static Future<void> _scheduleSingleNotification(
      String prayerName, int hour, int minute, tz.TZDateTime baseDate) async {
    final scheduledTime = tz.TZDateTime(
      tz.local,
      baseDate.year,
      baseDate.month,
      baseDate.day,
      hour,
      minute,
    );

    await _notificationsPlugin.zonedSchedule(
      _generateNotificationId(prayerName, scheduledTime),
      'موعد الصلاة',
      'حان الآن موعد صلاة ${_getPrayerNameArabic(prayerName)}',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_channel_id',
          'مواعيد الصلاة',
          importance: Importance.max,
          priority: Priority.high,
          // تم إزالة خصائص الصوت
          enableVibration: true, // يمكنك الاحتفاظ بالاهتزاز أو إزالته
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static int _generateNotificationId(String prayerName, tz.TZDateTime date) {
    return prayerName.hashCode + date.day + date.month * 100 + date.year * 10000;
  }

  static Future<void> showTestNotification() async {
    try {
      print('محاولة عرض إشعار اختبار...');
      await _notificationsPlugin.show(
        9999,
        'اختبار الإشعارات',
        'هذا إشعار تجريبي',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_channel_id',
            'مواعيد الصلاة',
            importance: Importance.max,
          ),
        ),
      );
      print('تم إرسال الإشعار بنجاح');
    } catch (e) {
      print('فشل إرسال الإشعار: $e');
    }
  }
  static String _getPrayerNameArabic(String english) {
    switch (english) {
      case 'Fajr':
        return 'الفجر';
      case 'Dhuhr':
        return 'الظهر';
      case 'Asr':
        return 'العصر';
      case 'Maghrib':
        return 'المغرب';
      case 'Isha':
        return 'العشاء';
      default:
        return english;
    }
  }
}