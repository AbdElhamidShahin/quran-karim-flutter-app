// notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      InitializationSettings(android: androidInit),
    );
  }

  /// لإظهار إشعار فوري (مستخدم في الـ callback)
  static Future<void> showPeriodicNotification({
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'periodic_channel',
          'Periodic Notifications',
          channelDescription: 'إشعارات كل 5 دقائق',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
    );
  }
}
void periodicNotificationCallback() {
  NotificationService.showPeriodicNotification(
    title: 'تذكير',
    body: 'هذا إشعار كل 5 دقائق',
  );
}