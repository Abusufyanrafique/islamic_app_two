import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/View/Listscreen/subscreen/AlreadyReciter/AppointmentRequest.dart';
import 'package:local_notification/View/Listscreen/subscreen/RegisterAsHafiz/RegisterAsHafiz.dart';
import 'package:local_notification/hajj_and_Umrah_guide/hajj_umrah_splash_screen.dart';
import '../../Utils/Constants/AllColors.dart';



class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "List",
          style:AppColors().customTextStyle12(
            color: AppColors.black,
          ).copyWith(
            fontSize: getFont(26)
          )
          ),
        ),
      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: getWidth(12),
          ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CustomContainer(
              //   "Profile",
              //   Column(
              //     children: [
              //       // AllListButton(
              //       //   "Profile",
              //       //   AllImages.premium,
              //       //   onTap: () {
              //       //     Navigator.push(
              //       //       context,
              //       //       MaterialPageRoute(
              //       //           builder: (context) =>
              //       //               ProfileScreen()
              //       //       ),
              //       //     );
              //       //     print("Fajr tapped!");
              //       //     // Or navigate to another screen
              //       //     // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
              //       //   },
              //       // ),
              //       // AllListButton(
              //       //   "My Premium",
              //       //   AllImages.premium,
              //       //   onTap: () {

              //       //     print("Fajr tapped!");
              //       //     // Or navigate to another screen
              //       //     // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
              //       //   },
              //       // ),
              //     ],
              //   ),
              // ),
              // CustomContainer(
              //   "Communication Prefrences",
              //   Column(
              //     children: [
              //       // AllListButton(
              //       //   "Free Newsletter",
              //       //   AllImages.newsletter,
              //       //   onTap: () {
              //       //     print("Fajr tapped!");
              //       //     // Or navigate to another screen
              //       //     // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
              //       //   },
              //       // ),
              //       // AllListButton(
              //       //   "Push Notification",
              //       //   AllImages.alarm,
              //       //   onTap: () {
              //       //     print("Fajr tapped!");
              //       //     // Or navigate to another screen
              //       //     // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
              //       //   },
              //       // ),
              //     ],
              //   ),
              // ),
              CustomContainer(
                "Feature Settings",
                Column(
                  children: [
                    AllListButton(
                      "Islamic Calendar",
                      AllImages.calender,
                      onTap: () {
                        print("Fajr tapped!");
                        // Or navigate to another screen
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
                      },
                    ),
                    AllListButton(
                      "Al Quran",
                      AllImages.quranic,
                      onTap: () {
                        print("Fajr tapped!");
                        // Or navigate to another screen
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
                      },
                    ),
                    AllListButton(
                      "Hadith",
                      AllImages.hadith,
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ChatScreen(
                        //           muftiName: "Ahmad",
                        //           muftiStatus: "Online",
                        //           muftiImage: "",
                        //         )
                        //       // ImamRegistrationScreen()
                        //     ));
                        print("Fajr tapped!");
                        // Or navigate to another screen
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
                      },
                    ),
                    AllListButton(
                      "Tasbih",
                      AllImages.tasbih,
                      onTap: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentRequest(muftiId: 3,)
                              // ImamRegistrationScreen()
                            ));
                        print("Fajr tapped!");
                        // Or navigate to another screen
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
                      },
                    ),

               AllListButton(
               "Labbaik",
               AllImages.tasbih,
               onTap: () {
               Navigator.push(
               context,
               MaterialPageRoute(
               builder: (context) => const HajjUmrahSplashScreen(),
      ),
    );
  },
),
                    AllListButton(
                      "Register as Hafiz",
                      AllImages.register,
                      onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ImamRegistrationScreen()
                          ));
                        print("Fajr tapped!");
                        // Or navigate to another screen
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
                      },
                    ),
                    // AllListButton(
                    //   "Already Reciter",
                    //   AllImages.reciter,
                    //   onTap: () {

                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 Alreadyreciter()
                    //         ));
                    //     print("Fajr tapped!");
                    //     // Or navigate to another screen
                    //     // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
                    //   },
                    // ),
                    // AllListButton(
                    //   "Islamic Video",
                    //   AllImages.videoicon,
                    //   onTap: () {
                    //     print("Fajr tapped!");
                    //     // Or navigate to another screen
                    //     // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
                    //   },
                    // ),
                  ],
                ),
              ),
              // CustomContainer(
              //   "App Settings",
              //   Column(
              //     children: [
              //       // AllListButton(
              //       //   "App Language",
              //       //   AllImages.language,
              //       //   onTap: () {
              //       //     print("Fajr tapped!");
              //       //     // Or navigate to another screen
              //       //     // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
              //       //   },
              //       // ),
              //       // AllListButton(
              //       //   "System Setting",
              //       //   AllImages.settingIcon,
              //       //   onTap: () {
              //       //     print("Fajr tapped!");
              //       //     // Or navigate to another screen
              //       //     // Navigator.push(context, MaterialPageRoute(builder: (_) => FajrScreen()));
              //       //   },
              //       // ),
              //     ],
              //   ),
              // ),


            ],
          ),
        ),
      ),
    );
  }

  Widget AllListButton(
    String title,
     String image, {
      VoidCallback? onTap
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getHeight(50),
        margin:  EdgeInsets.symmetric(vertical: getHeight(8),),
        padding:  EdgeInsets.symmetric(
          horizontal: getWidth(12), 
          vertical: getHeight(2)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Left Image
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey.shade100,
              child: SvgPicture.asset(
                image,
                width: getWidth(14),
                height: getHeight(14),
                color: Colors.black,
                fit: BoxFit.contain,
              ),
            ),
             SizedBox(width: getWidth(12)),

            /// Title
            Expanded(
              child: Text(
                title,
                style: AppColors().customTextStyle12(
                  color: AppColors.black,
                  ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget CustomContainer(
    String title, 
    Widget widget,
    ) {
    return Container(

      margin:  EdgeInsets.symmetric(vertical: getHeight(8),),
      padding:  EdgeInsets.symmetric(
        horizontal: getWidth(12), 
        vertical: getHeight(10)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, 
          style: AppColors().customTextStyle14(
            fontWeight:FontWeight.w500,
            )),
          widget,
        ],
      ),
    );
  }
}
