import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/veiw/screens/HomePage.dart';
import 'package:quran_app/veiw/screens/SplashScreen.dart'; // استيراد الصفحة الجديدة
import 'package:quran_app/veiw/screens/Settings.dart';
import 'package:quran_app/veiw_model/helper/saveLastReadPage.dart';
import 'package:quran_app/veiw_model/helper/thems/ThemeProviderDarkMode.dart';
import 'package:quran_app/veiw_model/helper/thems/color.dart';
import 'model/ItemProvider.dart';
import 'model/api/apiServise.dart';
import 'model/api/playAdhanServise.dart';
import 'model/bloc/bloc.dart';




void main() async {


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
        scaffoldBackgroundColor: backgroundColor(context), // خلفية الوضع العادي
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121B22), // #121B22
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: SplashScreen(),
      ),
    );
  }
}
