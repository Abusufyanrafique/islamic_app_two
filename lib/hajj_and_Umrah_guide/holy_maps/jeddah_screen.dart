import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/Widgets/holy_search_bar.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/floating_mosque_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/historic_jeddah_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/information_centre_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/international_airport_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/jeddah_islamic_port_screen.dart';


class JeddahScreen extends StatelessWidget {
  const JeddahScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final List<CategoryItem> categories =  [
     CategoryItem(
      title: 'king Airport',
       imagePath: AllImages.kingAirport,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  InternationalAirportScreen(),
        ),
      );
       }
       ),
    CategoryItem(
      title: 'Historic jeddah', 
      imagePath: AllImages.historicJeddah,
      onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HistoricJeddahScreen(),
        ),
      );
       }
      ),
    CategoryItem(
      title: 'Jeddah Islamic Port',
       imagePath: AllImages.jeddahIslamicPort,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const JeddahIslamicPortScreen(),
        ),
      );
       }
       ),
    CategoryItem(
      title: 'floating Mosque',
       imagePath: AllImages.floatingmosque,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const FloatingMosqueScreen (),
        ),
      );
       }
       ),
    CategoryItem(
      title: 'information Centre', 
      imagePath: AllImages.informationCentre,
      onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  InformationCentreScreen(),
        ),
      );
       }
      ),
       
      
  ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AllText.jeddah,
          style:AppColors().customTextStyle18().copyWith(
            fontSize: getFont(26)
          )
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getHeight(8)),
            HolySearchBar(onMenuTap: () {}),
            SizedBox(height: getHeight(20)),
            Text(
              'Categories',
              style: TextStyle(
                fontSize: getFont(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getHeight(12)),
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: getWidth(12),
                  mainAxisSpacing: getHeight(12),
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];

                  return GestureDetector(
                    onTap: item.onTap,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(getWidth(12)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            item.imagePath,
                            fit: BoxFit.cover,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: getHeight(12),
                                
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.labbaik,
                                //  borderRadius: BorderRadius.only(
                                //  topLeft: Radius.circular(12),
                                //  topRight: Radius.circular(12),
                                //          ),
                              ),
                              
                              child: Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getFont(13),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryItem({
    required this.title,
    required this.imagePath,
    this.onTap,
  });
}