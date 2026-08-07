import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class MountainsScreen extends StatelessWidget {
  const MountainsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Mountains',
      imagePath: AllImages.mountain,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Mountains of Makkah'),

          const NumberedHeading(number: 1, title: 'Jabal al-Nour (Mountain of Light)'),
          const BodyText('Home to Cave of Hira (Ghar Hira).'),
          const BodyText(
            'The Prophet Muhammad ﷺ received the first revelation of the '
            "Qur'an here through Angel Jibreel (AS).",
          ),
          const BulletItem(
            'Google Maps: https://maps.google.com/?q=Jabal+Al+Nour+Makkah',
            linkUrl: 'https://maps.google.com/?q=Jabal+Al+Nour+Makkah',
          ),

          const NumberedHeading(number: 2, title: 'Jabal Thawr'),
          const BulletItem('Contains Cave of Thawr (Ghar Thawr).'),
          const BulletItem(
            'The Prophet ﷺ and Abu Bakr (RA) stayed here for three days '
            'during the Hijrah to Madinah.',
          ),
          const MapLink(url: 'https://maps.google.com/?q=Jabal+Thawr+Makkah'),

          const NumberedHeading(number: 3, title: 'Jabal al-Rahmah (Mount of Mercy)'),
        ],
      ),
    );
  }
}