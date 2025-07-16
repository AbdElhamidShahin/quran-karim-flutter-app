import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quran_app/veiw/screens/HomePage.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../model/api/NotificationService.dart';
import '../../model/api/scheduleDailyPrayerNotifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final prefs = await SharedPreferences.getInstance();
    bool isScheduled = prefs.getBool('notificationsScheduled') ?? false;

    // انتقال سريع للصفحة الرئيسية
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );

    // جدولة الإشعارات بعد الدخول
    if (!isScheduled) {
      unawaited(scheduleDailyPrayerNotifications());
      // await prefs.setBool('notificationsScheduled', true);
    }

    // إشعار اختبار بعد 10 ثواني (اختياري)
    await NotificationService.showScheduledNotification(
      prayerName: "اختبار",
      time: "الآن",
      scheduledTime: tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/Image HomeScreen/logoApp.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
