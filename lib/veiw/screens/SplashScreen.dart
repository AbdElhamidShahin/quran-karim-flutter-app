import 'package:flutter/material.dart';
import 'HomePage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        // يجعل الصورة تاخد كل الشاشة
        child: Image.asset(
          'assets/Image HomeScreen/logoApp.png',
          fit: BoxFit.cover, // أو استخدم BoxFit.fill حسب النتيجة اللي تعجبك
        ),
      ),
    );
  }
}
