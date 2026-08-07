import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class SevenMosquesScreen extends StatelessWidget {
  const SevenMosquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Seven Mosques',
      imagePath: AllImages.seven,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Seven Mosques'),

          const BulletItem('📍 Near the site of the Battle of\n the Trench (Khandaq).'),
          const BulletItem('A group of historic mosques \nassociated with the battle.'),
          const MapLink(
            url: 'https://maps.google.com/?q=Seven+Mosques+Madinah',
          ),
        ],
      ),
    );
  }
}