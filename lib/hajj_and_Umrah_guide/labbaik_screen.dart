import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/hajj_and_Umrah_guide/dua/dua_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/hajj_retuals/hajj_retuals_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/holy_maps_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/preals_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/prayer_time/prayer_time_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/umrah_retuals_screen.dart';

class LabbaikScreen extends StatelessWidget {
  const LabbaikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final items = [
      {"title": "Umrah\nGuide", "icon":"assets/icons/Umrah_s.svg"},
      {"title": "Hajj\nGuide", "icon": "assets/icons/Hajjguides.svg"},
      {"title": "Dua", "icon": "assets/icons/duas.svg"},
      {"title": "Prayer\nTime", "icon": "assets/icons/PrayerTimes.svg"},
      {"title": "Holy\nMaps", "icon": "assets/icons/HolyMapss.svg"},
      {"title": "16 Madani\nPearl", "icon":"assets/icons/madnis.svg" },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBanner(),
            GestureDetector(
              onTap: () {},
              child: Text(
                AllText.labbaik,
                style: AppColors().customTextStyleBold10(
                  color: AppColors.labbaik,
                  fontWeight: FontWeight.w800,
                ).copyWith(
                  fontSize: getFont(32),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: getHeight(6)),
            Text(
              AllText.yourHajjandUmrahguide,
              style: AppColors().customTextStyleBold16(
                color: AppColors.black,
              ).copyWith(fontSize: getFont(14)),
            ),
            Image(image: AssetImage("assets/images/masjid.png")),
            
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(24),
                ),
              child: Wrap(
                spacing: getWidth(16),
                runSpacing: getHeight(2), 
                alignment: WrapAlignment.center,
                children: List.generate(
                  items.length,
                  (index) => MenuCard(
                    title: items[index]["title"] as String,
                    iconAsset: items[index]["icon"] as String,
                    onTap: () => _navigate(context, items[index]["title"] as String),
                  ),
                ),
              ),
            ),
            SizedBox(height: getHeight(30)),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String title) {
    Widget screen;

    switch (title) {
      case "Umrah\nGuide":
        screen = const UmrahRitualsScreen();
        break;
      case "Hajj\nGuide":
        screen = const HajjRetualsScreen();
        break;
      case "Dua":
        screen = const DuaScreen();
        break;
      case "Prayer\nTime":
        screen = const PrayerTimeScreen1();
        break;
      case "Holy\nMaps":
        screen = const HolyMapsScreen();
        break;
      case "Travel\nGuide":
        screen = const _PlaceholderScreen(title: "Travel Guide");
        break;
      case "16 Madani\nPearl":
        screen = const MadniPearlsScreen();
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class TopBanner extends StatelessWidget {
  const TopBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: _BannerCurveClipper(),
          child: SizedBox(
            width: double.infinity,
            height: getHeight(302),
            child: Image.asset(
              "assets/images/image11.png",
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Back arrow - top left
        Positioned(
          top: getHeight(16),
          left: getWidth(16),
          child: SafeArea(
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.pop(context),
              child: Container(
                width: getWidth(40),
                height: getWidth(40),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _BannerCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 5);

    path.quadraticBezierTo(
      size.width / 2,
      size.height - 100,  
      size.width,
      size.height - 30,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
class MenuCard extends StatelessWidget {
  final String title;
  final String iconAsset; 
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.iconAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: getWidth(166),
        height: getHeight(164),
        margin: EdgeInsets.only(
          top: getHeight(22),
          ), 
        padding: EdgeInsets.only(
          left: getWidth(16),
          bottom: getHeight(14),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
      image:  DecorationImage(
      image: AssetImage(AllImages.containerimage),
      fit: BoxFit.cover,
    ),
        
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
           
            Positioned(
              top: -getHeight(-10),
              left: getWidth(4),
              child: Container(
                width: getWidth(56),
                height: getWidth(56),
                padding: EdgeInsets.all(getWidth(11)),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: _CardIcon(iconAsset: iconAsset),
              ),
            ),

            // Title - bottom left
            Positioned(
              left: 10,
              right: getWidth(36),
              bottom: getHeight(6),
              child: Text(
                title,
                style: AppColors().customTextStyle18(
                  color: AppColors.white,
                ).copyWith(
                  fontSize: getFont(19),
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ),

            // Arrow - bottom right
            Positioned(
              right: 10,
              bottom: 0,
              child: Container(
                width: getWidth(26),
                height: getWidth(26),
                decoration:  BoxDecoration(
                  color: AppColors.white.withOpacity(0.50),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width:0.5,
                  )
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: getFont(12),
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _CardIcon extends StatelessWidget {
  final String? iconAsset;

  const _CardIcon({required this.iconAsset});

  @override
  Widget build(BuildContext context) {
    // Agar path hi nahi diya gaya to seedha placeholder dikhao
    if (iconAsset == null || iconAsset!.trim().isEmpty) {
      return const _PlaceholderIcon();
    }

    return SvgPicture.asset(
      iconAsset!,
      fit: BoxFit.contain,
      placeholderBuilder: (context) => const _PlaceholderIcon(),
    );
  }
}

/// Default/fallback icon widget
class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.image_not_supported_outlined,
      size: getFont(20),
      color: AppColors.labbaik.withOpacity(0.6),
    );
  }
}

// Temporary placeholder — jab tak actual screens ready nahi hain
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Screen — Coming Soon')),
    );
  }
}