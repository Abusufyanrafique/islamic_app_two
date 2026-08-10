import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/View/OnBoardingScreen/OnBoardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState() {
    super.initState();
    navigateNext();

  }
  Future<bool> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isFirstTime") ?? true;
  }
  Future<void> navigateNext() async {
  await Future.delayed(const Duration(seconds: 5));

  if (!mounted) return;

  // ===========================
  // Testing Navigation
  // 1. OnBoarding Screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => OnBoardingScreen(),
    ),
  );

  // 2. Bottom Navigation Screen
  /*
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => BottomNavScreen(),
    ),
  );
  */

  // 3. Kisi aur Screen par jana ho
  /*
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => YourScreen(),
    ),
  );
  */
}

  // Future<void> navigateNext() async {
  //   await Future.delayed(
  //     const Duration(seconds: 3),
  //   );
  //   bool firstTime = await checkFirstTime();
  //   if (!mounted) return;
  //   if (firstTime) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(

  //         builder: (_) => OnBoardingScreen(),
  //       ),
  //     );
  //   } else {

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(

  //         builder: (_) => BottomNavScreen(),
  //       ),
  //     );

  //   }

  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AllImages.splashback,
            ),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: getHeight(50)),
          
              Image.asset(
                AllImages.splashbackimage,
                width: 260,
              ),
              // const Spacer(),
              SizedBox(height: getHeight(180),),
              Image(
              height: getHeight(160),
              width: getWidth(200),
              image:AssetImage("assets/images/categories/app_logo.jpeg"), ),
              SizedBox(height: getHeight(20),),
              Text(
                "Islamic App",
                style: AppColors()
                    .customTextStyleBold10()
                    .copyWith(
                      fontSize: getFont(22),
          
                    ),
          
              ),
              SizedBox(height: getHeight(50),),
          
              const Spacer(),
              Image.asset(
                height: getHeight(250),
                width: double.infinity, 
                 fit: BoxFit.fill,  
                AllImages.masjidimage,
                
              ),
            ],
          
          ),

        ),

      ),

    );

  }

}