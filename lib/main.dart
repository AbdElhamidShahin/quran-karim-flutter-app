import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'model/api/NotificationService.dart';
import 'veiw/screens/SplashScreen.dart';
import 'model/api/apiServise.dart';
import 'model/ItemProvider.dart';
import 'model/bloc/bloc.dart';
import 'veiw_model/helper/thems/ThemeProviderDarkMode.dart';
import 'veiw_model/helper/thems/color.dart';

import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // اطلب إذن الإشعارات
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  await NotificationService.init();

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
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: SplashScreen(),
        ),
      ),
    );
  }
}
