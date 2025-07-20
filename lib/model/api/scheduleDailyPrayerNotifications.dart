import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static const String _prayerTimesKey = 'prayer_times';
  static const String _lastUpdateKey = 'last_update';

  static Future<void> savePrayerTimes(Map<String, String> times) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prayerTimesKey, json.encode(times));
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  static Future<Map<String, String>> loadPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final timesJson = prefs.getString(_prayerTimesKey);
    final lastUpdate = prefs.getString(_lastUpdateKey);

    // إذا مر أكثر من يوم على آخر تحديث، نعيد بيانات فارغة
    if (lastUpdate != null) {
      final lastDate = DateTime.parse(lastUpdate);
      if (DateTime.now().difference(lastDate) > Duration(days: 1)) {
        return {};
      }
    }

    return timesJson != null
        ? Map<String, String>.from(json.decode(timesJson))
        : {};
  }

  static Future<void> clearOldData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prayerTimesKey);
    await prefs.remove(_lastUpdateKey);
  }
}