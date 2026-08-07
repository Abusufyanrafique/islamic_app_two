import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/Widgets/ritual_text_widgets.dart';

class RitualItem {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const RitualItem({
    required this.title,
    required this.imagePath,
    this.onTap,
  });
}

class DuaScreen extends StatelessWidget {
  const DuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const _HeaderSection(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getHeight(19)),
                  const RitualTitle("Dua's"),

                  const RitualHeading('Essential Duas for Umrah & \nHajj'),

                  const RitualStepHeading('1. Talbiyah (After Entering\n Ihram)'),
                 Text(
                 "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، "
                 "إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ",
                style: AppColors().customTextStyle18().copyWith(
                fontSize: getFont(18),
                height: 1.3,
  ),
),
                  const RitualHeading('Translation:'),
                  const RitualBodyText(
                    '"Here I am, O Allah, here I am. Here\n I am, You have no '
                    'partner.\n Surely all praise, blessings,\n and sovereignty '
                    'belong to You.\n You have no partner."',
                  ),

                  const RitualStepHeading('2. At the Black Stone (Hajar\n al-Aswad)'),
                  const RitualBulletItem('بِسْمِ اللَّهِ، اللَّهُ أَكْبَرُ'),
                  const RitualHeading('Translation:'),
                  const RitualBodyText(
                    '"In the name of Allah, Allah is\n the Greatest."',
                  ),

                  const RitualStepHeading('3. Between the Yemeni'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------ HEADER SECTION ------------------
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        height: getHeight(190),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEAF7F8),
              Color(0xFFDFF1F3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 20,
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  AllImages.sameimage,
                  height: getHeight(130),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getWidth(16),
                  vertical: getHeight(8),
                ),
                child: Row(
                  children: [
                    _BackButton(
                      onTap: () => Navigator.maybePop(context),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    AllText.labbaik,
                    style: AppColors().customTextStyleBold10(
                      color: AppColors.labbaik,
                      fontWeight: FontWeight.w800,
                    ).copyWith(
                      fontSize: getFont(46),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: getHeight(4)),
                  Text(
                    AllText.yourHajjandUmrahguide,
                    style: AppColors().customTextStyleBold16(
                      color: AppColors.black,
                    ).copyWith(fontSize: getFont(17)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Icon(
          Icons.arrow_back,
          color: AppColors.black,
        ),
      ),
    );
  }
}