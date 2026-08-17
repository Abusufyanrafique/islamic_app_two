import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/View/Islamic_Calander/Islamic_Calander.dart';
import 'package:local_notification/View/QuranScreen/QuranScreen.dart';
import 'package:local_notification/View/privacy_policy/privacy_policy_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/hajj_umrah_splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/Constants/AllColors.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  Future<void> _openYouTubeVideo() async {
    final Uri url =
        Uri.parse('https://www.youtube.com/watch?v=m9-Umj3aL1I');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint('YouTube URL open nahi hua');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.12),
          child: Container(
            color: const Color(0xFF6B7678),
            height: 0.12,
          ),
        ),
        title: Text(
          "List",
          style: AppColors().customTextStyleBold16().copyWith(
                fontSize: getFont(16),
              ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomContainer(
                "Feature Settings",
                Column(
                  children: [
                    AllListButton(
                      "Islamic Calendar",
                      AllImages.calender,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => IslamicCalendar()),
                        );
                      },
                    ),
                    AllListButton(
                      "Al Quran",
                      AllImages.quranic,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => JuzListScreens()),
                        );
                      },
                    ),
                    AllListButton(
                      "Labbaik",
                      AllImages.tasbih,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HajjUmrahSplashScreen(),
                          ),
                        );
                      },
                    ),

                    // ✅ Privacy Policy — Flutter built-in shield icon
                    AllListButton(
                      "Privacy Policy",
                      "",
                      iconData: Icons.privacy_tip_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PrivacyPolicyScreen()),
                        );
                      },
                    ),

                    // ✅ Live — YouTube open karta hai
                    AllListButton(
                      "Live",
                      AllImages.videoicon,
                      onTap: () {
                        _openYouTubeVideo();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// [iconData] pass karo toh Flutter ka built-in icon use hoga
  /// warna SVG asset use hoga
  Widget AllListButton(
    String title,
    String image, {
    VoidCallback? onTap,
    IconData? iconData, // ✅ optional Flutter icon
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getHeight(50),
        margin: EdgeInsets.symmetric(vertical: getHeight(8)),
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(12), vertical: getHeight(2)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            /// ✅ iconData ho toh Flutter Icon, warna SVG
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey.shade100,
              child: iconData != null
                  ? Icon(
                      iconData,
                      size: getWidth(18),
                      color: Colors.black,
                    )
                  : SvgPicture.asset(
                      image,
                      width: getWidth(14),
                      height: getHeight(14),
                      color: Colors.black,
                      fit: BoxFit.contain,
                    ),
            ),
            SizedBox(width: getWidth(12)),
            Expanded(
              child: Text(
                title,
                style: AppColors().customTextStyle12(
                  color: AppColors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SvgPicture.asset(
              'assets/icons/arrowforward.svg',
              width: getWidth(20),
              height: getHeight(20),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomContainer(
    String title,
    Widget widget,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: getHeight(8)),
      padding: EdgeInsets.symmetric(
          horizontal: getWidth(12), vertical: getHeight(10)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppColors().customTextStyle14(
                fontWeight: FontWeight.w500,
              )),
          widget,
        ],
      ),
    );
  }
}