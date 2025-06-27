import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'model/ItemProvider.dart';
import 'model/api/NotificationService.dart';
import 'model/api/apiServise.dart';
import 'model/bloc/bloc.dart';
import 'veiw/screens/SplashScreen.dart';
import 'veiw_model/helper/thems/ThemeProviderDarkMode.dart';
import 'veiw_model/helper/thems/color.dart';
import 'veiw_model/helper/Position/getPosition.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
@pragma('vm:entry-point')
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    tz.initializeTimeZones();
    final position = await getPosition();
    final prayerService = PrayerService();
    final prayerTimes = await prayerService.fetchPrayerTimes(
      position.latitude,
      position.longitude,
    );

    final now = DateTime.now();

    for (var entry in prayerTimes.entries) {
      final name = entry.key;
      final time = entry.value;

      final parts = time.split(':');
      if (parts.length != 2) continue;

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour == null || minute == null) continue;

      final scheduledTime = tz.TZDateTime.local(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // لو الصلاة لسه جاية، وجدول إشعارها
      if (scheduledTime.isAfter(now)) {
        await NotificationService.showScheduledNotification(
          prayerName: name,
          time: time,
          scheduledTime: scheduledTime,
        );
      }
    }

    return true;
  });
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.request();

  await NotificationService.init();
  await Permission.notification.request();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  await Workmanager().registerPeriodicTask(
    "prayerTask",
    "daily_prayer_scheduler",
    frequency: const Duration(hours: 24),
    initialDelay: const Duration(seconds: 10),
    constraints: Constraints(networkType: NetworkType.connected),
  );


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(
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
