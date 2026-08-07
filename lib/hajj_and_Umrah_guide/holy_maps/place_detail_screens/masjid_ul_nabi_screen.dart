import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class MasjidUlNabiScreen extends StatelessWidget {
  const MasjidUlNabiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Masjid ul Nabi',
      imagePath: AllImages.masjidulnabi1,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Masjid ul Nabi'),

          const BulletItem('📍 The second holiest mosque in \nIslam.'),
          const BulletItem(
            "Home to the Prophet Muhammad\n ﷺ's Mosque, the Green Dome, "
            "and\n the Prophet's ﷺ resting place.",
          ),
          const MapLink(
            url: 'https://maps.google.com/?q=Al+Masjid+an+Nabawi+Madinah',
          ),
        ],
      ),
    );
  }
}