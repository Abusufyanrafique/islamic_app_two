import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class WellsScreen extends StatelessWidget {
  const WellsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Wells',
      imagePath: AllImages.wellsbig,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Historic Wells of Makkah'),

          const NumberedHeading(number: 1, title: 'Zamzam Well'),
          const BulletItem('Miraculously provided by Allah for Hajar (AS) and Ismail (AS).'),
          const BulletItem('The holiest and most famous well in Islam.'),
          const BulletItem('Pilgrims drink Zamzam water during Hajj and Umrah.'),
          const MapLink(url: 'https://maps.google.com/?q=Zamzam+Well+Makkah'),

          const NumberedHeading(number: 2, title: 'Tuwa Well'),
          const BulletItem('A historic well from the pre-Islamic era.'),
          const BulletItem(
            'The Prophet Muhammad ﷺ stayed here and performed ablution before '
            'entering Makkah during the Conquest of Makkah.',
          ),
        ],
      ),
    );
  }
}