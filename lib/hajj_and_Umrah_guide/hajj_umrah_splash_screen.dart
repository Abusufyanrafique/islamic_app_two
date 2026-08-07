import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/hajj_and_Umrah_guide/labbaik_screen.dart';


class HajjUmrahSplashScreen extends StatefulWidget {
  const HajjUmrahSplashScreen({super.key});

  @override
  State<HajjUmrahSplashScreen> createState() =>
      _HajjUmrahSplashScreenState();
}

class _HajjUmrahSplashScreenState extends State<HajjUmrahSplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LabbaikScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const _TopImageSection(),
          SizedBox(height: getHeight(55)),
          const _TitleSection(),
        ],
      ),
    );
  }
}

class _TopImageSection extends StatelessWidget {
  const _TopImageSection();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(60),
      ),
      child: Column(
        children: [
             Image.asset(
        AllImages.labbaik,
        fit: BoxFit.cover,
      ),
        ],
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children:  [
        Text(
           AllText.labbaik,
  style: AppColors().customTextStyleBold10(
    color: AppColors.labbaik,
    fontWeight: FontWeight.w800,
  ).copyWith(
    fontSize: getFont(26),
    letterSpacing: 0.5,
  ),
),
        SizedBox(height: getHeight(12)),
        Text(
          AllText.yourHajjandUmrahguide,
          
          style: AppColors().customTextStyleBold16(
            color:AppColors.black,
             ).copyWith(
              fontSize: getFont(17)
             )
        ),
      ],
    );
  }
}