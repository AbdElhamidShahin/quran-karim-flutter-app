import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'veiw/screens/SplashScreen.dart';
import 'model/api/NotificationService.dart';
import 'model/api/apiServise.dart';
import 'model/ItemProvider.dart';
import 'model/bloc/bloc.dart';
import 'veiw_model/helper/thems/ThemeProviderDarkMode.dart';
import 'veiw_model/helper/thems/color.dart';
import 'veiw_model/helper/Position/getPosition.dart';

Future<void> scheduleDailyPrayerNotifications() async {
  try {
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

      final scheduleTime = tz.TZDateTime.local(now.year, now.month, now.day, hour, minute);

      if (scheduleTime.isAfter(now)) {
        await NotificationService.showScheduledNotification(
          prayerName: name,
          time: entry.value,
          scheduledTime: scheduleTime,
        );
      }
    }

    print("✅ إشعارات الصلوات تم جدولتها بنجاح");
  } catch (e) {
    print("❌ Error in scheduleDailyPrayerNotifications: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await NotificationService.init();
  await Permission.notification.request();
  await AndroidAlarmManager.initialize();

  // ⏰ جدولة كل يوم 24 ساعة يعيد حساب مواعيد الصلاة
  await AndroidAlarmManager.periodic(
    const Duration(hours: 24),
    1,
    scheduleDailyPrayerNotifications,
    startAt: DateTime.now().add(const Duration(seconds: 10)),
    exact: true,
    wakeup: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (_) => PrayerBloc(PrayerService(), Connectivity())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'تطبيق القرآن',
        themeMode: ThemeMode.system,
        theme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.light,
          scaffoldBackgroundColor: backgroundColor(context),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121B22),
        ),
        home:  Directionality(
          textDirection: TextDirection.rtl,
          child: SplashScreen(),
        ),
      ),
    );
  }
}
