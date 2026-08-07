
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Utils/Constants/AllColors.dart';
import '../Utils/Constants/AllImages.dart';
import '../Utils/Constants/SizeConfig.dart';
import '../View/Home/HomeScreen.dart';
import '../View/Prayer/PrayersTimeScreen.dart';
import '../View/Qibla/QiblaScreen.dart';
import '../View/QuranScreen/QuranScreen.dart';
import 'package:adhan_dart/adhan_dart.dart';

import 'package:geolocator/geolocator.dart';
class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {

  int selectedIndex = 0;

  final List<Widget> screens =  [
    HomeScreen(),
    PrayerTimeScreen(),
    JuzListScreens(),
  //  QuranPakScreen(),
    QiblaScreen()

  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
     // extendBody: true,
      body: screens[selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,

        child: Container(
          margin: EdgeInsets.only(
            left: getWidth(29),
            right: getWidth(29),
            bottom: getHeight(5),

          ),
          padding:  EdgeInsets.symmetric(
            horizontal: getWidth(6), 
            vertical: getHeight(6)
            ),
          // height: getHeight(48),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25),
            // border: Border.all(
            //   color: AppColors.kGreyColor,
            //   width: 0.12
            // )
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                spreadRadius: 0,
              //  offset: const Offset(1, 1),
                color: Colors.black.withOpacity(0.25),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navItem(
                index: 0,
                icon: AllImages.home,
                selectedIcon: AllImages.homefill,
                label: "Home",
              ),
              navItem(
                index: 1,
                icon: AllImages.prayer,
                selectedIcon: AllImages.prayerfill,
                label: "prayer",
              ),
              navItem(
                index: 2,
                icon: AllImages.qurannav,
                selectedIcon: AllImages.quranfill,
                label: "Quran",
              ),
              navItem(
                index: 3,
                icon: AllImages.qiblanav,
                selectedIcon: AllImages.qiblanav,
                label: "Qibla",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required int index,
    required String icon,
    required String selectedIcon,
    required String label,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: isSelected

          ? Container(
        padding:  EdgeInsets.symmetric(horizontal: getWidth(9),),
        height: getHeight(38),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Container(

              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.circular(50),

                  border: Border.all(
                    width: getWidth(2),
                    color: AppColors.primaryColor)
              ),
              child: SvgPicture.asset(
                selectedIcon,
                //color: AppColors.white,
                height: getHeight(24),
              ),
            ),
            SizedBox(width: getWidth(3)),
            Text(
                label,style: AppColors().customTextStyle12(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  ),

            ),
          ],
        ),
      )

          :
      CircleAvatar(
        radius: 18,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 2,
              color: AppColors.primaryColor,
            ),
          ),
          child: SvgPicture.asset(
            icon,
            height: getHeight(20),
            width: getWidth(20),
          ),
        ),
      ),


      // Container(
      //   padding: EdgeInsets.symmetric(horizontal:3,vertical: 3),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(50),
      //
      //     border: Border.all(width: 2,color: AppColors.primaryColor)
      //   ),
      //       child: SvgPicture.asset(
      //               icon,height: 20,
      //           width: 20,
      //               //  color: AppColors.kGreenColor,
      //               //  height: getHeight(28),
      //             ),
      //     ),
    );
  }
}

class HomePagess extends StatefulWidget {
  const HomePagess({super.key});

  @override
  State<HomePagess> createState() => _HomePageState();
}

class _HomePageState extends State<HomePagess> {
  Future<Position>? getPosition;

  @override
  void initState() {
    super.initState();
    getPosition = _determinePosition();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Qibla Finder App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<Position>(
          future: getPosition,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Position positionResult = snapshot.data!;
              Coordinates coordinates = Coordinates(
                positionResult.latitude,
                positionResult.longitude,
              );
              double qiblaDirection = Qibla.qibla(
                coordinates,
              );
              return Text("");

            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {

    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}
String showHeading(double direction, double qiblaDirection) {
  return qiblaDirection.toInt() != direction.toInt()
      ? '${direction.toStringAsFixed(0)}°'
      : "You're facing Makkah!";
}
