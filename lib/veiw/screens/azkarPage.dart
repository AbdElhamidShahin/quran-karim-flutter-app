import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import '../../model/azkarModel/ItemAzkatr.dart';
import '../../model/azkarModel/SearchScreenAzkar.dart';
import '../../model/azkarModel/azkarJsonScreen.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../wedgit/Custom SearchScreen.dart';
import '../wedgit/CustomAppBar.dart';
import '../wedgit/CustomAzkarPage.dart';

class AzkarPage extends StatelessWidget {
  const AzkarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ('الأذكار')),
      body: Column(
        children: [
          CustomSearchscreen(
            text: 'ابحث عن الاذكار',
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          FutureBuilder<List<AzkarCategoryModel>>(
            future: fetchAzkarCategoryFromJson(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: accentColor),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'حدث خطأ أثناء تحميل البيانات',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('لا توجد بيانات متاحة', style: appBodyStyle()),
                );
              }

              final categories = snapshot.data!;

              return Expanded(
                child: GridView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: const EdgeInsets.all(8),
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: .5,
                    mainAxisSpacing: 0.5,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return CustomAzkarPage(azkarCategory: categories[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
