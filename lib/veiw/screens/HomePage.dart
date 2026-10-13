import 'package:flutter/material.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../wedgit/Dashboard.dart';
import '../wedgit/LastReadWidget.dart';
import 'Settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width  = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: backgroundColor(context),
      endDrawer: Drawer(child: Column(children: [Expanded(child: Setings())])),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        // Settings / drawer toggle
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: Icon(Icons.menu_rounded, color: primaryColor, size: 26),
              tooltip: 'الإعدادات',
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
        title: Text('القرآن الكريم', style: appBarTitleStyle()),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Greeting banner ──────────────────────────────────────────
              _GreetingBanner(isDark: isDark),
              const SizedBox(height: 16),
              // ── Last-reading card ────────────────────────────────────────
              LastReadWidget(width: width, height: height),
              const SizedBox(height: 8),
              // ── Feature cards ────────────────────────────────────────────
              Dashboard(height: height),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small decorative greeting shown under the AppBar.
class _GreetingBanner extends StatelessWidget {
  final bool isDark;
  const _GreetingBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.12),
            accentColor.withOpacity(0.07),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          const Text('✨', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'بسم الله الرحمن الرحيم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? primaryLight : primaryDark,
                ),
              ),
              Text(
                'أهلاً بك في تطبيق القرآن',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
