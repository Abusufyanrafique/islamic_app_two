import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/Widgets/ritual_text_widgets.dart';

class DayOfTarwiyaScreen extends StatelessWidget {
  const DayOfTarwiyaScreen({super.key});

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
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(16),
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getHeight(19)),
                  const RitualTitle('Day of Tarwiya'),
                  const ArabicVerse(
                    'وَأَذِّنْ فِي النَّاسِ بِالْحَجِّ يَأْتُوكَ رِجَالًا '
                    'وَعَلَىٰ كُلِّ ضَامِرٍ يَأْتِينَ مِن كُلِّ فَجٍّ عَمِيقٍ',
                  ),

                  const RitualHeading('Day of Tarwiya'),
                  const RitualBodyText(
                    '8th of Dhul-Hijjah – The First\n Day of Hajj',
                  ),

                 Image(image: AssetImage(AllImages.enterIhram)),

                  const RitualHeading('1. Enter Ihram'),
                  const RitualBulletItem(
                    "Pilgrims performing \nHajj Tamattu' enter Ihram\n again from \n"
                    'their place of stay in Makkah.',
                  ),
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