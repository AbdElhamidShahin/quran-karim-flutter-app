import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PrayerService {
  final Dio _dio;
  PrayerService({Dio? dio})
      : _dio = dio ??
      Dio(BaseOptions(
        baseUrl: 'https://api.aladhan.com/v1',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));

  Future<Map<String, String>> fetchPrayerTimes(double lat, double lng) async {
    final now = DateTime.now();
    final response = await _dio.get('/timings', queryParameters: {
      'latitude': lat,
      'longitude': lng,
      'method': 4,
      'school': 0,
      'timezonestring': 'Africa/Cairo',
      'date': '${now.day}-${now.month}-${now.year}',
    });

    if (response.statusCode == 200) {
      final timings = response.data['data']['timings'] as Map<String, dynamic>;
      return _parsePrayerTimes(timings, now); // نمرر now للدالة
    } else {
      throw Exception('Failed to fetch prayer times');
    }
  }

  Map<String, String> _parsePrayerTimes(Map<String, dynamic> timings, DateTime now) {
    // للاختبار: استخدام أوقات بعد دقائق من الآن
    bool useTestTimes = true; // غير هذه القيمة لـ false عند الانتهاء من الاختبار

    if (useTestTimes) {
      return {
        'الفجر': _formatTestTime(now, 1),
        'الظهر': _formatTestTime(now, 2),
        'العصر': _formatTestTime(now, 3),
        'المغرب': _formatTestTime(now, 4),
        'العشاء': _formatTestTime(now, 5),
      };
    } else {
      // البيانات الحقيقية من API
      return {
        'الفجر': _formatTime(timings['Fajr']),
        'الظهر': _formatTime(timings['Dhuhr']),
        'العصر': _formatTime(timings['Asr']),
        'المغرب': _formatTime(timings['Maghrib']),
        'العشاء': _formatTime(timings['Isha']),
      };
    }
  }

  // دالة مساعدة لإنشاء أوقات اختبارية
  String _formatTestTime(DateTime now, int minutesToAdd) {
    final time = now.add(Duration(minutes: minutesToAdd));
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime(String timeStr) {
    final parts = timeStr.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (parts.length > 1 && parts[1] == 'PM' && hour < 12) {
      hour += 12;
    }
    if (parts.length > 1 && parts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}