import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> prayerData = {
  'الفجر': {'icon': Icons.brightness_2, 'image': 'assets/Images sala/1.jpg'},
  'الظهر': {'icon': Icons.wb_sunny, 'image': 'assets/Images sala/2.jpg'},
  'العصر': {'icon': Icons.cloud, 'image': 'assets/Images sala/3.jpg'},
  'المغرب': {'icon': Icons.brightness_6, 'image': 'assets/Images sala/4.jpg'},
  'العشاء': {
    'icon': Icons.nightlight_round,
    'image': 'assets/Images sala/5.jpg',
  },
};
String getFormattedTime(String time24) {
  try {
    final timeParts = time24.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = timeParts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  } catch (e) {
    return time24;
  }
}
