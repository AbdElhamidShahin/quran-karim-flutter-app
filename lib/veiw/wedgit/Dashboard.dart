import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/veiw/screens/azkarPage.dart';
import 'package:quran_app/veiw/wedgit/CustomContainer.dart';

import '../../model/PrayerTime.dart';
import '../../model/api/NotificationService.dart';
import '../../model/api/scheduleDailyPrayerNotifications.dart';
import '../../model/bloc/bloc.dart';
import '../../veiw_model/helper/Position/getPosition.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../screens/My_QuranPage.dart';
import '../screens/PrayerTimesScreen.dart';
import '../screens/sephaScreen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: Column(
            children: [
              // في أي صفحة من تطبيقك، أضف هذا الزر للاختبار الشامل
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await NotificationService.showTestNotification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم إرسال إشعار اختبار')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('فشل إرسال الإشعار: $e')),
                        );
                      }
                    },
                    child: Text('اختبار الإشعار الفوري'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final testTimes = {
                          'الفجر': '${DateTime.now().hour}:${(DateTime.now().minute + 1) % 60}',
                          'الظهر': '${DateTime.now().hour}:${(DateTime.now().minute + 2) % 60}',
                        };
                        await NotificationService.schedulePrayerNotifications(testTimes);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم جدولة إشعارات اختبار بعد 1 و 2 دقائق')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('فشل الجدولة: $e')),
                        );
                      }
                    },
                    child: Text('اختبار جدولة الإشعارات'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final times = await LocalStorageHelper.loadPrayerTimes();
                        print('المواقيت المخزنة: $times');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم تحميل المواقيت. انظر السجلات للتفاصيل')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('فشل تحميل المواقيت: $e')),
                        );
                      }
                    },
                    child: Text('عرض المواقيت المخزنة'),
                  ),
                ],
              ),
              CustomContainer(
                height1: height * .2,
                image: 'assets/Image HomeScreen/unnamed.png',
                title: "المسبحه",
                color: qiblaColor,
                onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SephaScreen()),
                  );
                },
              ),
              CustomContainer(
                height1: height * .27,
                image: 'assets/Image HomeScreen/islam_14415965.png',
                title: "أذكار الصباح والمساء",
                color: lastReadingColor,
                onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AzkarPage()),
                  );
                },
              ),
            ],
          ),
        ),
        Spacer(),
        SizedBox(
          child: Column(
            children: [
              CustomContainer(
                height1: height * .27,
                image: 'assets/Image HomeScreen/al-quran_15660541.png',
                title: "القرأن الكريم",
                color: quranColor,
                onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyQuranPage()),
                  );
                },
              ),
              CustomContainer(
                height1: height * .20,
                image: 'assets/Image HomeScreen/sujud_15044855.png',
                title: "مواقيت الصلاه",
                color: azkarColor,
                onpressed: () async {
                  try {
                    final position = await getPosition(); // استخدام دالتك

                    context.read<PrayerBloc>().add(FetchPrayerTimes(
                        lat: position.latitude, lng: position.longitude));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrayerTimesScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("error"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
