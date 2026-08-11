import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/hajj_and_Umrah_guide/day_of_Arafah/day_of_arafah_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/day_of_nahr/day_of_nahr_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/day_of_tarwiya/day_of_tarwiya_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/days_of_tashreeq/days_of_tashreeq_screen.dart';




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

class HajjRetualsScreen extends StatelessWidget {
  const HajjRetualsScreen({super.key});

 
  @override
  Widget build(BuildContext context) {
    final List<RitualItem> _rituals = [
    RitualItem(
      title: AllText.dayatTarwiyah,
      imagePath:AllImages.dayatTarwiyah,
      onTap: () {
         Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (_) => const DayOfTarwiyaScreen(),
        ),
      );
      },
    ),
    RitualItem(
      title: AllText.dayofArafah,
      imagePath: AllImages.dayofArafah,
      onTap: () {
         Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (_) => const DayOfArafahScreen(),
        ),
      );
      },
    ),
    RitualItem(
      title: AllText.dayofNahr,
      imagePath: AllImages.dayofNahr,
      onTap: () {
         Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (_) => const DayOfNahrScreen(),
        ),
      );
      },
    ),
            RitualItem(
            title: AllText.dayofTashreeq,
            imagePath:AllImages.dayoftashreeq,
            onTap: () {
            Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (_) => const DayOfTashreeqScreen (),
        ),
      );
      },
    ),
  ];

     SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _HeaderSection(),
          Expanded(
            child: ListView(
              padding:  EdgeInsets.symmetric(
                horizontal: getWidth(16),
                vertical: getHeight(20),
              ),
              children: [
                 _SectionTitle(title: AllText.hajjRetuals),
                 SizedBox(height: getHeight(20)),
                ..._rituals.map(
                  (item) => Padding(
                    padding:  EdgeInsets.only(
                      bottom: 16,
                      ),
                    child: _RitualCard(item: item),
                  ),
                ),
              ],
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
    return Container(
      height: getHeight(190),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AllImages.sameimage), // 
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Top bar: back button
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
          // Title + subtitle
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
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: getHeight(4)),
                Text(
                  AllText.yourHajjandUmrahguide,
                  style: AppColors().customTextStyleBold16(
                    color: AppColors.black,
                  ).copyWith(fontSize: getFont(14)),
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
      child:  Padding(
        padding: EdgeInsets.all(6.0),
        child: Icon(
          Icons.arrow_back, 
          color: AppColors.black,
          ),
      ),
    );
  }
}

/// ------------------ SECTION TITLE ------------------
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style:AppColors().customTextStyleBold800(
          color: AppColors.labbaik
        ).copyWith(
          fontSize: getFont(24)
        )
      ),
    );
  }
}

/// ------------------ RITUAL CARD ------------------
class _RitualCard extends StatelessWidget {
  final RitualItem item;
  const _RitualCard({required this.item});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: item.onTap,
        child: Container(
          height: getHeight(92),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.25),
                offset: const Offset(0, 1),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: Image.asset(
                  item.imagePath,
                  width: getWidth(90),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: getWidth(90),
                    color: AppColors.darkBackgroundColor,
                  ),
                ),
              ),
              SizedBox(width: getWidth(14)),
              Expanded(
                child: Center(
                  child: Text(
                    item.title,
                    style: AppColors().customTextStyleBold800(
                      color: AppColors.labbaik,
                    ).copyWith(
                      fontSize: getFont(18)
                    )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: getWidth(20)),
                child:  SvgPicture.asset(
            'assets/icons/arrowforward.svg',
            width: getWidth(20),
            height: getHeight(20),
),
              ),
            ],
          ),
        ),
      ),
    );
  }
}