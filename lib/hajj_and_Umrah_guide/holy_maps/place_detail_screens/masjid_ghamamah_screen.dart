import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class MasjidGhamamahScreen extends StatelessWidget {
  const MasjidGhamamahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Masid e Ghamamah',
      imagePath: AllImages.sameimage,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Masjid al-Ghamamah'),

          const BulletItem('📍 Southwest of Al-Masjid an-Nabawi.'),
          const BulletItem(
            'Traditionally associated with the Prophet ﷺ performing Eid and '
            'Istisqa (rain) prayers.',
          ),
          const MapLink(
            url: 'https://maps.google.com/?q=Masjid+al+Ghamamah+Madinah',
          ),
        ],
      ),
    );
  }
}