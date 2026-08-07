import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class MosquesScreen extends StatelessWidget {
  const MosquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Mosques',
      imagePath: AllImages.mosqueimage,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Mosques of Makkah'),

          const NumberedHeading(number: 1, title: 'Masjid al-Haram'),
          const BodyText('The holiest mosque in Islam.'),
          const BodyText(
            'Home to the Kaaba, Maqam Ibrahim, Hijr Ismail, Zamzam Well, '
            'and the Safa & Marwah area.',
          ),
          const BulletItem(
            'Google Maps: https://maps.google.com/?q=Masjid+al+Haram+Makkah',
            linkUrl: 'https://maps.google.com/?q=Masjid+al+Haram+Makkah',
          ),

          const NumberedHeading(number: 2, title: 'Masjid Aisha (Masjid al-Taneem)'),
          const BulletItem(
            'One of the most common Miqat locations for people already in '
            'Makkah who wish to enter Ihram again for another Umrah.',
          ),
          const BulletItem(
            'Named after Aisha (RA), who entered Ihram here for Umrah '
            'during the Farewell Pilgrimage.',
          ),
          const MapLink(url: 'https://maps.google.com/?'),
        ],
      ),
    );
  }
}