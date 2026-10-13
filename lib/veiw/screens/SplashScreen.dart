import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../veiw_model/helper/thems/color.dart';
import 'HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    // Hide system UI for a cleaner splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1800), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              SizedBox(
                width: 160,
                height: 160,
                child: Image.asset(
                  'assets/Image HomeScreen/logoApp.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.menu_book_rounded,
                    color: primaryColor,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'القرآن الكريم',
                style: TextStyle(
                  fontFamily: 'Lalezar',
                  fontSize: 32,
                  color: primaryColor,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'بسم الله الرحمن الرحيم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  color: primaryLight.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
