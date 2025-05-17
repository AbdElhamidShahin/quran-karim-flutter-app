import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerService {
  final Dio _dio;
  final AudioPlayer _audioPlayer = AudioPlayer();

  PrayerService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://api.aladhan.com/v1',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<Map<String, String>> fetchPrayerTimesIfNeeded(double lat, double lng) async {
    final response = await Dio().get(
      'https://api.aladhan.com/v1/timings',
      queryParameters: {
        'latitude': lat,
        'longitude': lng,
        'method': 5,  'timezonestring': DateTime.now().timeZoneName,

        // Egyptian General Authority
      },
    );

    if (response.statusCode == 200) {
      final timings = response.data['data']['timings'] as Map<String, dynamic>;
      return timings.map((key, value) => MapEntry(key, value.toString()));
    } else {
      throw Exception("Failed to fetch prayer times");
    }
  }
  Future<Map<String, String>> fetchPrayerTimes(double lat, double lng) async {
    try {
      final now = DateTime.now();
      final timeZone = now.timeZoneOffset.inHours;

      final response = await _dio.get('/timings', queryParameters: {
        'latitude': lat,
        'longitude': lng,
        'method': 5, // Egyptian General Authority
        'timezonestring': 'Africa/Cairo', // أو استخدام timeZone
        'date': '${now.day}-${now.month}-${now.year}',
      });

      if (response.statusCode == 200) {
        final timings = response.data['data']['timings'] as Map<String, dynamic>;
        return _parsePrayerTimes(timings);
      }
      throw 'Failed to load prayer times: ${response.statusCode}';
    } catch (e) {
      debugPrint('Error fetching prayer times: $e');
      throw 'Failed to load prayer times: $e';
    }
  }

  Future<void> playAdhan(String prayerName) async {
    String adhanFile = '4032.mp3';
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(adhanFile));
    debugPrint('✅ تم تشغيل الأذان لصلاة $prayerName');
  }

  Map<String, String> _parsePrayerTimes(Map<String, dynamic> timings) {
    final result = <String, String>{};

    // الأوقات الأساسية
    result['الفجر'] = _formatTime(timings['Fajr']);
    result['الظهر'] = _formatTime(timings['Dhuhr']);
    result['العصر'] = _formatTime(timings['Asr']);
    result['المغرب'] = _formatTime(timings['Maghrib']);
    result['العشاء'] = _formatTime(timings['Isha']);

    return result;
  }

  String _formatTime(String timeStr) {
    try {
      final parts = timeStr.split(' ');
      final timeParts = parts[0].split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // تحويل إلى تنسيق 24 ساعة
      if (parts.length > 1 && parts[1] == 'PM' && hour < 12) {
        return '${hour + 12}:${minute.toString().padLeft(2, '0')}';
      }
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timeStr.split(' ')[0]; // العودة إلى القيمة الأصلية في حالة الخطأ
    }
  }
}
