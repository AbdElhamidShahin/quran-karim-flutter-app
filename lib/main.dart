import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/veiw_model/helper/Position/getPosition.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:quran_app/veiw/screens/SplashScreen.dart';
import 'package:quran_app/veiw_model/helper/thems/ThemeProviderDarkMode.dart';
import 'package:quran_app/veiw_model/helper/thems/color.dart';
import 'model/ItemProvider.dart';
import 'model/api/apiServise.dart';
import 'model/api/playAdhanServise.dart';
import 'model/bloc/bloc.dart';

@pragma('vm:entry-point')
void prayerNotificationCallback() async {
  try {
    final prayerService = PrayerService();
    final position = await getPosition();
    final prayerTimes = await prayerService.fetchPrayerTimes(
      position.latitude,
      position.longitude,
    );

    final now = DateTime.now();
    String currentPrayer = '';

    // تحديد الصلاة الحالية
    for (final entry in prayerTimes.entries) {
      final timeParts = entry.value.split(':');
      final prayerTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      if (now.isAfter(prayerTime.subtract(const Duration(minutes: 2)))) {
        currentPrayer = entry.key;
      }
    }

    if (currentPrayer.isNotEmpty) {
      await NotificationService.showPrayerNotification(
        prayerName: currentPrayer,
        prayerTime: prayerTimes[currentPrayer]!,
      );
    }
  } catch (e) {
    debugPrint('Error in prayer notification: $e');
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    prayerNotificationCallback();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await NotificationService.initialize();
  await AndroidAlarmManager.initialize();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // تسجيل المهمة الدورية كل 15 دقيقة (أقل فترة مسموحة)
  await Workmanager().registerPeriodicTask(
    "prayer-task",
    "prayerNotification",
    frequency: const Duration(minutes: 15),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        BlocProvider<PrayerBloc>(
          create: (_) => PrayerBloc(PrayerService(), Connectivity()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'تطبيق القرآن',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: SplashScreen(),
      ),
    );
  }
}
