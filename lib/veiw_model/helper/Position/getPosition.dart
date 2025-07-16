import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getPosition() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    throw 'يجب تفعيل خدمة الموقع';
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'تم رفض إذن الوصول للموقع';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw 'تم رفض إذن الموقع بشكل دائم، يرجى تفعيله من الإعدادات';
  }

  return await Geolocator.getCurrentPosition();
}

Future<String> getCityName(double lat, double lng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      return placemarks.first.locality ?? "مدينة غير معروفة";
    }
    return "مدينة غير معروفة";
  } catch (e) {
    debugPrint("خطأ في جلب اسم المدينة: $e");
    return "مدينة غير معروفة";
  }
}
