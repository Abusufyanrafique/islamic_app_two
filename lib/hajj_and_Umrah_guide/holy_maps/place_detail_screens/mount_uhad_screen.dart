import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class MountUhadScreen extends StatelessWidget {
  const MountUhadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Mount Uhad',
      imagePath: AllImages.mountUhad,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Mount Uhud'),

          const BulletItem('📍 About 5 km north of \nthe Prophet\'s Mosque.'),
          const BulletItem('Site of the Battle of Uhud and \nthe Uhud Martyrs\' Cemetery.'),
          const MapLink(
            url: 'https://maps.google.com/?q=Mount+Uhud+Madinah',
          ),
        ],
      ),
    );
  }
}