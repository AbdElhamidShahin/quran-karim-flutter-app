import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../veiw_model/helper/AboutAppPage.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/ThemeProviderDarkMode.dart';
import '../../veiw_model/helper/thems/color.dart';

class Setings extends StatelessWidget {
  const Setings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: ListView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(height: 32),
            _buildSettingsOption(
              context,
              icon: Icons.privacy_tip,
              title: 'سياسة الخصوصية',
              onPressed: () {
                _launchUrl(
                  "https://www.privacypolicies.com/live/17f74ba9-74a8-486e-abc5-12e159600ce5",
                );
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.star,
              title: 'تقييم التطبيق',
              onPressed: () {
                _launchUrl("");
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.share,
              title: 'مشاركة',
              onPressed: () {
                Share.share(
                  'https://play.google.com/store/apps/details?id=com.yourcompanyname.yourappname&fbclid=IwZXh0bgNhZW0CMTAAAR1zobhWeqLMCQDh_XmcPyNn7xHySVpG1MSrQs70NWFhZ_17bsnXV9936ls_aem_xXW5vyMyfUmyH9kifCQD1Q',
                );
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.warning,
              title: 'تحذير',
              onPressed: () {
                _showWarningDialog(context);
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.question_answer_sharp,
              title: 'عن التطبيق',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutAppPage()),
                );
              },
            ),
            Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                leading: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: primaryDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: primaryDark,
                    size: 22,
                  ),
                ),
                title: Text(
                  isDarkMode ? 'الوضع الليلي' : 'الوضع النهاري',
                  style: SttingsTextStyle(),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: primaryDark,
                ),
              ),
            ),
            _buildSettingsOption(
              context,
              icon: Icons.chat_outlined,
              title: 'تواصل معنا',
              onPressed: () {
                _launchUrl("https://mail.google.com/mail/?view=cm&fs=1&to=abdelhamid.shahin0@gmail.com");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Icon(icon, color: primaryDark, size: 24),
        title: Text(title, style: SttingsTextStyle()),
        onTap: onPressed,
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    if (!await launchUrl(Uri.parse(urlString))) {
      throw Exception("Could not launch $urlString");
    }
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'تحذير',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: const Text(
            'هذه رسالة تحذير.',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}
