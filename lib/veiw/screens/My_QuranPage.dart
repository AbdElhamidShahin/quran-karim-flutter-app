import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../model/azkarModel/Seaarch ScreenSora.dart';
import '../../model/item.dart';
import '../../model/JsonScreen.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../wedgit/Custom SearchScreen.dart';
import '../wedgit/CustomAppBar.dart';
import '../wedgit/CustomQuranPage.dart';

class MyQuranPage extends StatelessWidget {
  const MyQuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130), // ارتفاع مخصص
        child: Column(
          children: [
            CustomAppBar(title: 'القرأن الكريم'),
            CustomSearchscreen(text: 'ابحث عن السوره', ontap: () {    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            ); },),
          ],
        ),
      ),


      body: Directionality(
        textDirection: TextDirection.rtl,

        child: FutureBuilder<List<Item>>(
          future: fetchSuraDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: accentColor),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading data',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No data available', style: appBodyStyle()),
              );
            }

            final suras = snapshot.data!;

            return AnimationLimiter(
              child: ListView.builder(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),

                padding: const EdgeInsets.all(16),
                itemCount: suras.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1000),

                    child: SlideAnimation(
                      verticalOffset: 50.0,

                      child: FadeInAnimation(
                        child: CustomQuranPage(
                          index: index,
                          sura: suras[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
