import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'model/api/apiServise.dart';
import 'veiw/screens/SplashScreen.dart';
import 'model/ItemProvider.dart';
import 'model/bloc/bloc.dart';
import 'veiw_model/helper/thems/ThemeProviderDarkMode.dart';
import 'veiw_model/helper/thems/color.dart';

void main() async {

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
