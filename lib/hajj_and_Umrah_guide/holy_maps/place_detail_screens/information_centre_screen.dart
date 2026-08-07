import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/preals_screen.dart';

class InformationCentreScreen extends StatelessWidget {
  const InformationCentreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'information Centre',
      imagePath: AllImages.informationCentre,
      content: GestureDetector(
        onTap: () {
           Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  MadniPearlsScreen(),
        ),
      );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle('Hajj & Umrah\n Information Centre'),
        
             BulletItem(
              'Provides information and guidance\n for pilgrims regarding '
              'Hajj and\n Umrah services.',
            ),
            SizedBox(height: getHeight(10),),
             BoldLabel('Google Maps'),
            const MapLink(
              label: '',
              url: 'https://maps.google.com/?q=King+Abdulaziz+International+Airport+Jeddah',
            ),
          ],
        ),
      ),
    );
  }
}