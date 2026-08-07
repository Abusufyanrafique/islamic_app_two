import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';

// getHeight / getWidth / getFont helpers

class MadniPearlsScreen extends StatelessWidget {
  const MadniPearlsScreen({super.key});

  static final List<_Pearl> pearls = [
    _Pearl(
      number: 1,
      title: 'Sincere Intention (Niyyah)',
      description:
          'Perform Hajj or Umrah solely to seek the pleasure of Allah, free from showing off or worldly motives.',
    ),
    _Pearl(
      number: 2,
      title: 'Learn the Rituals',
      description:
          'Study the correct method of Hajj and Umrah before traveling so you can perform every act according to the Sunnah.',
    ),
    _Pearl(
      number: 3,
      title: 'Repent Sincerely',
      description:
          "Seek Allah's forgiveness for all past sins and begin your journey with a pure heart.",
    ),
    _Pearl(
      number: 4,
      title: 'Settle Rights and Debts',
      description:
          'Return trusts, repay debts where possible, and seek forgiveness from anyone you may have wronged.',
    ),
    _Pearl(
      number: 5,
      title: 'Use Halal Earnings',
      description:
          'Ensure that your travel expenses and spending during the journey come from lawful (halal) earnings.',
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const _HeaderSection(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(20),
                vertical: getHeight(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '16 Madni Pearls',
                      style: AppColors()
                          .customTextStyleBold16(color: AppColors.labbaik)
                          .copyWith(
                            fontSize: getFont(26),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  SizedBox(height: getHeight(12)),
                  Text(
                    '16 Madani Pearls for Hajj\n & Umrah',
                    style: AppColors()
                        .customTextStyleBold16(color: AppColors.black)
                        .copyWith(
                          fontSize: getFont(22),
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                  ),
                  SizedBox(height: getHeight(18)),
                  ...pearls.map((pearl) => _PearlItem(pearl: pearl)),
                  SizedBox(height: getHeight(20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pearl {
  final int number;
  final String title;
  final String description;

  _Pearl({
    required this.number,
    required this.title,
    required this.description,
  });
}

class _PearlItem extends StatelessWidget {
  final _Pearl pearl;

  const _PearlItem({required this.pearl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: getHeight(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${pearl.number}. ${pearl.title}',
            style: AppColors()
                .customTextStyleBold16(
                  color: AppColors.black,)
                .copyWith(
                  fontSize: getFont(16), 
                  fontWeight: FontWeight.w700,),
          ),
          SizedBox(height: getHeight(4)),
          Text(
            pearl.description,
            style: AppColors()
                .customTextStyleBold16(
                  color: AppColors.black.withOpacity(0.7))
                .copyWith(
                  fontSize: getFont(15),
                  height: 1.45,
                  fontWeight: FontWeight.normal,
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
                  // _BackButton(onTap: () => Navigator.maybePop(context)),
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
                  ).copyWith(fontSize: getFont(46), letterSpacing: 0.5),
                ),
                SizedBox(height: getHeight(4)),
                Text(
                  AllText.yourHajjandUmrahguide,
                  style: AppColors().customTextStyleBold16(color: AppColors.black)
                      .copyWith(fontSize: getFont(17)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class SevenMosquesScreen extends StatelessWidget {
  const SevenMosquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Seven Mosques',
      imagePath: AllImages.seven,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Seven Mosques'),

          const BulletItem('📍 Near the site of the Battle of\n the Trench (Khandaq).'),
          const BulletItem('A group of historic mosques \nassociated with the battle.'),
          const MapLink(
            url: 'https://maps.google.com/?q=Seven+Mosques+Madinah',
          ),
        ],
      ),
    );
  }
}