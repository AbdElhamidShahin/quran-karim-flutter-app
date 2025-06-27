import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PrayerService {
  final Dio _dio;

  PrayerService()
      : _dio = Dio(BaseOptions(
    baseUrl: 'https://api.aladhan.com/v1',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<Map<String, String>> fetchPrayerTimes(double lat, double lng) async {
    try {
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
        final timings =
        response.data['data']['timings'] as Map<String, dynamic>;
        return {
          'الفجر': _formatTime(timings['Fajr']),
          'الظهر': _formatTime(timings['Dhuhr']),
          'العصر': _formatTime(timings['Asr']),
          'المغرب': _formatTime(timings['Maghrib']),
          'العشاء': _formatTime(timings['Isha']),
        };
      } else {
        debugPrint('⚠️ HTTP error: ${response.statusCode}');
        throw Exception('فشل في تحميل مواقيت الصلاة: ${response.statusCode}');
      }
    } catch (e, s) {
      debugPrint('❌ Exception while fetching prayer times: $e');
      debugPrint('StackTrace: $s');
      // يمكنك هنا إعادة بيانات افتراضية أو رمي الخطأ
      return {
        'الفجر': '05:00',
        'الظهر': '12:00',
        'العصر': '15:00',
        'المغرب': '18:00',
        'العشاء': '19:30',
      };
    }
  }

  String _formatTime(String timeStr) {
    try {
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
    } catch (e) {
      debugPrint('❌ Error formatting time: $e');
      return timeStr.split(' ')[0]; // fallback
    }
  }
}
