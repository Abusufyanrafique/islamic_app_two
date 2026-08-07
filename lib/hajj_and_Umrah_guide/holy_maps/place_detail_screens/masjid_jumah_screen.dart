import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class MasjidJumahScreen extends StatelessWidget {
  const MasjidJumahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Masjid al-Jumah',
      imagePath: AllImages.masjidJumah,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Masjid al-Jumu\'ah'),

          const BulletItem('📍 Near Quba Mosque.'),
          const BulletItem(
            'Traditionally regarded as the \nsite of the first Jumu\'ah prayer\n '
            'led by the Prophet ﷺ after the\n Hijrah.',
          ),
          const MapLink(
            url: 'https://maps.google.com/?q=Masjid+Al+Jumuah+Madinah',
          ),
        ],
      ),
    );
  }
}