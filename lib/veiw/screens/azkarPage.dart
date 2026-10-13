import 'package:flutter/material.dart';
import '../../model/azkarModel/AzkarCategoryModel.dart';
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
      appBar: CustomAppBar(title: 'الأذكار'),
      // NO location banner here — location is only needed for prayer times
      body: Column(
        children: [
          CustomSearchscreen(
            text: 'ابحث عن الاذكار',
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchScreen()),
            ),
          ),
          FutureBuilder<List<AzkarCategoryModel>>(
            future: fetchAzkarCategoryFromJson(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: errorColor, size: 48),
                        const SizedBox(height: 12),
                        Text('حدث خطأ أثناء تحميل البيانات',
                            style: appBodyStyle()
                                .copyWith(color: errorColor)),
                      ],
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text('لا توجد بيانات متاحة',
                        style: appBodyStyle()),
                  ),
                );
              }

              final categories = snapshot.data!;
              return Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: categories.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    // Reduced aspect ratio → shorter cards, more visible at once
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (ctx, index) =>
                      CustomAzkarPage(azkarCategory: categories[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
