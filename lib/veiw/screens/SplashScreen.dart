import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/api/NotificationService.dart';
import '../../model/api/apiServise.dart'; // هذا يحتوي على PrayerService
import '../../model/api/scheduleDailyPrayerNotifications.dart';
import 'HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 1. التحقق من إذن الموقع
      final hasLocationPermission = await _checkLocationPermission();
      if (!hasLocationPermission) return;

      // 2. الحصول على الموقع الحالي
      final position = await _getCurrentPosition();

      // 3. جلب مواقيت الصلاة
      final prayerTimes = await _fetchPrayerTimes(position);

      // 4. جدولة الإشعارات
      await _scheduleNotifications(prayerTimes);

      // 5. الانتقال للصفحة الرئيسية
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } catch (e) {
      _handleError(e);
    }
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showLocationPermissionDialog();
        return false;
      }
    }
    return true;
  }

  Future<Position> _getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'خدمة الموقع غير مفعلة';
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Map<String, String>> _fetchPrayerTimes(Position position) async {
    try {
      final prayerService = PrayerService();
      final times = await prayerService.fetchPrayerTimes(
        position.latitude,
        position.longitude,
      );
      await LocalStorageHelper.savePrayerTimes(times);
      return times;
    } catch (e) {
      final cachedTimes = await LocalStorageHelper.loadPrayerTimes();
      if (cachedTimes.isEmpty) throw 'لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة';
      return cachedTimes;
    }
  }

  Future<void> _scheduleNotifications(Map<String, String> prayerTimes) async {
    await NotificationService.init();
    await NotificationService.schedulePrayerNotifications(prayerTimes);
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إذن الموقع مطلوب'),
        content: const Text(
            'يحتاج التطبيق إلى إذن الموقع لتحديد مواقيت الصلاة الدقيقة.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  void _handleError(dynamic error) {
    print('خطأ في التهيئة: $error');
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حدث خطأ'),
        content: Text(error.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeApp();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/Image HomeScreen/logoApp.png'),
      ),
    );
  }
}