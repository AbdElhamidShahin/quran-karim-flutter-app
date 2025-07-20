import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'model/api/NotificationService.dart';
import 'model/api/apiServise.dart';
import 'model/api/scheduleDailyPrayerNotifications.dart';
import 'veiw/screens/SplashScreen.dart';
import 'model/ItemProvider.dart';
import 'model/bloc/bloc.dart';
import 'veiw_model/helper/thems/ThemeProviderDarkMode.dart';
import 'veiw_model/helper/thems/color.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // 1. الحصول على الموقع الحالي
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 2. جلب مواعيد الصلاة
      final prayerService = PrayerService();
      final prayerTimes = await prayerService.fetchPrayerTimes(
        position.latitude,
        position.longitude,
      );

      // 3. حفظ المواعيد محليًا
      await LocalStorageHelper.savePrayerTimes(prayerTimes);

      // 4. جدولة الإشعارات
      await NotificationService.schedulePrayerNotifications(prayerTimes);

      return true;
    } catch (e) {
      // في حالة الخطأ، استخدام المواعيد المخزنة
      final cachedTimes = await LocalStorageHelper.loadPrayerTimes();
      if (cachedTimes.isNotEmpty) {
        await NotificationService.schedulePrayerNotifications(cachedTimes);
      }
      return false;
    }
  });
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الوقت المنطقي
  tz.initializeTimeZones();

  // تهيئة خدمة الإشعارات
  await NotificationService.init();

  // تهيئة Workmanager للمهام الخلفية
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false, // تغيير إلى false في الإصدار النهائي
  );

  // تسجيل المهمة الدورية
  await Workmanager().registerPeriodicTask(
    'prayer_notifications_task',
    'update_prayer_times',
    frequency: const Duration(hours: 12), // تحديث كل 12 ساعة
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: false,
      requiresStorageNotLow: false,
    ),
    initialDelay: const Duration(seconds: 10),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: SplashScreen(),
      ),
    );
  }
}
