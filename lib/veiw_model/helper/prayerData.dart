import 'package:flutter/material.dart';

/// Maps each prayer name to its icon and hero image.
/// Icons are semantically correct — no gear/settings icon for Maghrib.
final Map<String, Map<String, dynamic>> prayerData = {
  'الفجر':  {'icon': Icons.brightness_2_outlined,  'image': 'assets/Images sala/1.jpg'},
  'الظهر':  {'icon': Icons.wb_sunny_outlined,       'image': 'assets/Images sala/2.jpg'},
  'العصر':  {'icon': Icons.cloud_outlined,          'image': 'assets/Images sala/3.jpg'},
  'المغرب': {'icon': Icons.wb_twilight_outlined,    'image': 'assets/Images sala/4.jpg'},
  'العشاء': {'icon': Icons.nightlight_round,        'image': 'assets/Images sala/5.jpg'},
};

/// Convert 24-hour "HH:mm" time string to a 12-hour display with AM/PM.
String getFormattedTime(String time24) {
  try {
    final parts  = time24.split(':');
    final hour   = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'م' : 'ص';  // Arabic AM/PM
    final h12    = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$h12:$minute $period';
  } catch (_) {
    return time24;
  }
}
