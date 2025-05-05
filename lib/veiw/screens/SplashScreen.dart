import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quran_app/veiw/screens/HomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
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
      body: Center(
        child: Image.asset(
          'assets/Image HomeScreen/logoApp.png',
          fit: BoxFit.cover,  // استخدم BoxFit.cover لتغطية كامل الشاشة
          width: double.infinity, // لعرض الصورة بالكامل
          height: double.infinity, // لتمديد الصورة لتغطية كامل الارتفاع
        ),
      )

    );
  }
}
