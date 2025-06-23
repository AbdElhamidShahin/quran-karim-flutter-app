import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quran_app/veiw/screens/HomePage.dart';

import '../../model/api/NotificationService.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    NotificationService.showPrayerNotification(prayerName: "الفجر", time: "05:00");
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(  // ياخد كل مساحة الشاشة
        child: Image.asset(
          'assets/Image HomeScreen/logoApp.png',
          fit: BoxFit.cover,  // أو جرب BoxFit.fill لو عايز يضغط الصورة
        ),
      ),
    );
  }

}