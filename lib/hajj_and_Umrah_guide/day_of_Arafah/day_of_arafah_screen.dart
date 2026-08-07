import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/Widgets/ritual_text_widgets.dart';

class DayOfArafahScreen extends StatelessWidget {
  const DayOfArafahScreen({super.key});

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
                  const RitualTitle('Day of Arafah'),
                  SizedBox(height: getHeight(5),),
                  const ArabicVerse('الحج عرفة'),

                  const RitualHeading('Day of Arafa'),
                  const RitualBodyText(
                    '9th of Dhul-Hijjah – The\n Greatest Day of Hajj',
                  ),
                  SizedBox(height: getHeight(30),),
                  Center(child: Image(image: AssetImage(AllImages.dayofrafah))),
                    SizedBox(height: getHeight(20),),
                  const RitualHeading('1. Travel from Mina to \nArafah'),
                  const RitualBulletItem(
                    'After Fajr in Mina, pilgrims\n travel to the Plain of\n Arafah.',
                  ),
                  SizedBox(height: getHeight(5),),
                  const RitualBulletItem('Continue reciting the Talbiyah.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(190),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AllImages.sameimage),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(16),
                vertical: getHeight(8),
              ),
              child: Row(
                children: [
                  _BackButton(onTap: () => Navigator.maybePop(context)),
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
                    fontSize: getFont(30),
                     letterSpacing: 0.5),
                ),
                SizedBox(height: getHeight(4)),
                Text(
                  AllText.yourHajjandUmrahguide,
                  style: AppColors().customTextStyleBold16(color: AppColors.black)
                      .copyWith(fontSize: getFont(14)),
                ),
              ],
            ),
          ),
        ],
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
        child: Icon(Icons.arrow_back, color: AppColors.black),
      ),
    );
  }
}