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
      return _parsePrayerTimes(timings);
    } else {
      throw Exception('Failed to fetch prayer times');
    }
  }

  Map<String, String> _parsePrayerTimes(Map<String, dynamic> timings) {
    return {
      'الفجر': _formatTime(timings['Fajr']),
      'الظهر': _formatTime(timings['Dhuhr']),
      'العصر': _formatTime(timings['Asr']),
      'المغرب': _formatTime(timings['Maghrib']),
      'العشاء': _formatTime(timings['Isha']),
    };
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
