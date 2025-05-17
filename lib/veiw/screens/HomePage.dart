import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../wedgit/Dashboard.dart';
import '../wedgit/LastReadWidget.dart';
import 'Settings.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      endDrawer: Drawer(child: Column(children: [Expanded(child: Setings())])),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: primaryColor),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
        title: Text("القرأن الكريم", style: appBarTitleStyle()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .07),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(bottom: height * .01),
                child: Center(
                  child: Image(
                    image: const AssetImage('assets/icons/logo.png'),
                    width: width * .3,
                  ),
                ),
              ),
              SizedBox(height: 12),
              LastReadWidget(width: width, height: height),
              Dashboard(height: height),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
