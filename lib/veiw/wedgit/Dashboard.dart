import 'package:flutter/material.dart';
import 'package:quran_app/veiw/screens/azkarPage.dart';
import 'package:quran_app/veiw/wedgit/CustomContainer.dart';

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
      children: [        SizedBox(
        child: Column(
          children: [
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

        Spacer(),        SizedBox(
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
                onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrayerTimesScreen()),
                  );
                },
              ),
            ],
          ),
        ),

      ],
    );
  }
}
