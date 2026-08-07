import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/Widgets/holy_search_bar.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/bir_uthman_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/jannat_ul_baqih_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/masjid_jumah_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/masjid_qiblatain_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/masjid_ul_nabi_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/mount_uhad_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/quba_mosque_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/rayad_ul_jannah_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/seven_mosques_screen.dart';

class MadinaScreen extends StatelessWidget {
  const MadinaScreen({super.key});

 
  @override
  Widget build(BuildContext context) {
     final List<CategoryItem> categories =  [
     CategoryItem(
      title: 'Seven Mosques',
       imagePath: AllImages.seven,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  SevenMosquesScreen(),
        ),
      );
       }
       ),
    CategoryItem(
      title: AllText.riyadulJannah, 
      imagePath: AllImages.riyadulJannah,
      onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const RayadUlJannahScreen(),
        ),
      );
       }
      ),
    CategoryItem(
      title: 'Masjid e Nabvi',
       imagePath: AllImages.masjidulNabvi,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MasjidUlNabiScreen(),
        ),
      );
       }
       ),
    CategoryItem(
      title: 'Jannat ul Baqih',
       imagePath: AllImages.jannatulBaqih,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const JannatUlBaqihScreen (),
        ),
      );
       }
       ),
    CategoryItem(
      title: 'Mount Uhad', 
      imagePath: AllImages.mountUhad,
      onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  MountUhadScreen(),
        ),
      );
       }
      ),
    CategoryItem(
      title: 'Masjid e Quba',
       imagePath: AllImages.masjideQuba,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  QubaMosqueScreen(),
        ),
      );
       }
       ),
        CategoryItem(
      title: 'Masid e Qiblatain', 
      imagePath: AllImages.qiblaimage,
      onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  MasjidQiblatainScreen(),
        ),
      );
       }
      ),
    CategoryItem(
      title: 'Masjid al Jumah',
       imagePath: AllImages.jummah,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  MasjidJumahScreen(),
        ),
      );
       }
       ),
       
         CategoryItem(
      title: 'Bir Uthman',
       imagePath: AllImages.biruthman,
       onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  BirUthmanScreen(),
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
          'Madina',
          style: TextStyle(
            color: Colors.black,
            fontSize: getFont(18),
            fontWeight: FontWeight.w600,
          ),
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
                                 borderRadius: BorderRadius.only(
                                //  topLeft: Radius.circular(12),
                                //  topRight: Radius.circular(12),
                                         ),
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