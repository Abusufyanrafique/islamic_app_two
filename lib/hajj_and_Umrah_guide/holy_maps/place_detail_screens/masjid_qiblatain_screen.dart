import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class MasjidQiblatainScreen extends StatelessWidget {
  const MasjidQiblatainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Masid e Qiblatain',
      imagePath: AllImages.qiblaimage,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Masjid al-Qiblatayn'),

          const BulletItem('📍 Northwest of Al-Masjid an-\nNabawi.'),
          const BulletItem(
            'The mosque where the Qiblah \nchanged from Jerusalem to the Kaaba.',
          ),
          const MapLink(
            url: 'https://maps.google.com/?q=Masjid+al+Qiblatayn+Madinah',
          ),
        ],
      ),
    );
  }
}