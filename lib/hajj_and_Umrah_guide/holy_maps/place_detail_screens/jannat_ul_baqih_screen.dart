import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class JannatUlBaqihScreen extends StatelessWidget {
  const JannatUlBaqihScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Jannat ul Baqih',
      imagePath: AllImages.jannatulBaqih,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Jannat ul Baqih'),

          const BulletItem('📍 Historic cemetery beside Al-\nMasjid an-Nabawi.'),
          const BulletItem(
            "Burial place of many members of \nthe Prophet's ﷺ family, "
            'wives,\n Companions, and early Muslims.',
          ),
          const MapLink(
            url: 'https://maps.google.com/?q=Jannat+al+Baqi+Madinah',
          ),
        ],
      ),
    );
  }
}