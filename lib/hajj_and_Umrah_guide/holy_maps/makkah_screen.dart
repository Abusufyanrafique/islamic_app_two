import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/Widgets/holy_search_bar.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/madina_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/cemetries_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/hajj_areas_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/mosques_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/mountains_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/museum_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/wells_screen.dart';

class MakkahScreen extends StatelessWidget {
   MakkahScreen({super.key});

 
  @override
  Widget build(BuildContext context) {
     final List<CategoryItem> categories =  [
    CategoryItem(
      title: 'Cemetries',
       imagePath:AllImages.cemetries,
       onTap: (){
         Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CemetriesScreen(),
        ),
      );
       }
       ),
    CategoryItem(
      title: 'Hajj Area',
      
      
      imagePath:AllImages.hajjArea,
      onTap: (){
         Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HajjAreasScreen(),
        ),
      );
      }
      ),
    // CategoryItem(
    //   title: 'Masjid ul Haram',
    //    imagePath:AllImages.masjidulHaram,
    //    onTap: (){
    //   //    Navigator.push(
    //   //   context,
    //   //   MaterialPageRoute(
    //   //     builder: (_) => const WellsScreen(),
    //   //   ),
    //   // );
    //   }
    //    ),
    CategoryItem(
      title: 'Mosque', 
      imagePath: AllImages.mosqueimage,
      onTap: (){
         Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MosquesScreen(),
        ),
      );
      }
      ),
    CategoryItem(
      title: 'Wells', 
      imagePath: AllImages.wells,
      onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const WellsScreen(),
        ),
      );
      }
      ),
    CategoryItem(
      title: 'Mountains', 
      imagePath: AllImages.mountain,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MountainsScreen(),
        ),
      );
      }
      ),
    //  CategoryItem(
    //   title: 'houses', 
    //   imagePath: AllImages.houese,
    //   ),
    CategoryItem(
      title: 'Musuem',
       imagePath: AllImages.musuem,
        onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MuseumScreen(),
        ),
      );
      }
       ),
  ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Makkah',
           style:AppColors().customTextStyleBold16().copyWith(
            fontSize: getFont(16),
          )
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(16),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getHeight(8)),
            HolySearchBar(onMenuTap: () {}),
            SizedBox(height: getHeight(20)),
            Text(
              AllText.categories,
               style:AppColors().customTextStyle18().copyWith(
                fontSize: getFont(16)
              )
            ),
            SizedBox(height: getHeight(12)),
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: getWidth(12),
                  mainAxisSpacing: getHeight(12),
                  childAspectRatio: 1.1,
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
                                 style:AppColors().customTextStyle18(
                                  color: AppColors.white
                                 ).copyWith(
                                 fontSize: getFont(16)
                           ) 
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