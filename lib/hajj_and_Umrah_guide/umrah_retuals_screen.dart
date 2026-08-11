import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/hajj_and_Umrah_guide/between_safa_marwa/between_safa_marwa.dart';
import 'package:local_notification/hajj_and_Umrah_guide/halq_Taqsir/halq_taqsir_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/intension_Ihram/intension_Ihram_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/tawaf/tawaf_screen.dart';


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

class UmrahRitualsScreen extends StatelessWidget {
  const UmrahRitualsScreen({super.key});

 
  @override
  Widget build(BuildContext context) {
    final List<RitualItem> _rituals = [
    RitualItem(
      title: AllText.intensionIhram,
      imagePath:AllImages.intensionIhram,
      onTap: () {
         Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (_) => const IntensionIhramScreen(),
        ),
      );
      },
    ),
    RitualItem(
      title: AllText.tawaf,
      imagePath: AllImages.tawaf,
      onTap: () {
         Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (_) => const TawafScreen(),
        ),
      );
      },
    ),
    RitualItem(
      title: AllText.betweenSafa,
      imagePath: AllImages.betweenSafaMarwa,
      onTap: () {
         Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (_) => const BetweenSafaMarwaScreen(),
        ),
      );
      },
    ),
    RitualItem(
      title: AllText.taqseeTrimmingHairs,
      imagePath:AllImages.taqseerTrimmingHairs ,
      onTap: () {
        Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (_) => const HalqTaqsirScreen (),
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
                 _SectionTitle(title: AllText.umrahRetuals),
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
          height: getHeight(100),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            // ✅ Border hata di, drop shadow laga di
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
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image.asset(
                  item.imagePath,
                  height: getHeight(100),
                  width: getWidth(103),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: getHeight(100),
                    width: getWidth(103),
                    color: AppColors.darkBackgroundColor,
                  ),
                ),
              ),
              SizedBox(width: getWidth(14)),
              Expanded(
                child: Center(
                  child: Text(
                    item.title,
                    style: AppColors()
                        .customTextStyleBold800(color: AppColors.labbaik)
                        .copyWith(fontSize: getFont(18)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: getWidth(20)),
                child:   SvgPicture.asset(
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