// main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

import 'model/api/scheduleDailyPrayerNotifications.dart';
import 'veiw/screens/SplashScreen.dart';
import 'model/api/NotificationService.dart';
import 'model/api/apiServise.dart';
import 'model/ItemProvider.dart';
import 'model/bloc/bloc.dart';
import 'veiw_model/helper/thems/ThemeProviderDarkMode.dart';
import 'veiw_model/helper/thems/color.dart';

Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid && Platform.version.compareTo("12") >= 0) {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await NotificationService.init();
  await Permission.notification.request();
  await requestExactAlarmPermission(); // ⏰ مهم جدًا

  await AndroidAlarmManager.initialize();

  final result = await AndroidAlarmManager.periodic(
    const Duration(hours: 24),
    1,
    scheduleDailyPrayerNotifications,
    exact: true,
    wakeup: true,
  );

  if (!result) {
    debugPrint('❌ فشل جدولة المنبه اليومي');
  }

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
