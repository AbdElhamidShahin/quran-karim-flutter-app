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
Future<bool> showLocationDisclosureDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text("الوصول إلى الموقع"),
      content: Text(
          "يحتاج التطبيق لتحديد موقعك بدقة من أجل عرض مواقيت الصلاة في مدينتك. "
              "لن يتم استخدام بيانات الموقع لأي غرض آخر."
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text("رفض"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text("موافق"),
        ),
      ],
    ),
  ) ?? false;
}
