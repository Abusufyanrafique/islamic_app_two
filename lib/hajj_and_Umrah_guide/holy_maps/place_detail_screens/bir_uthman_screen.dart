import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class BirUthmanScreen extends StatelessWidget {
  const BirUthmanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Bir Uthman',
      imagePath: AllImages.biruthman,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Bir Uthman'),

          const BulletItem(
            '📍 Historic well purchased \nby Caliph Uthman ibn Affan (RA) for\n '
            'the benefit of Muslims.',
          ),
          const MapLink(
            url: 'https://maps.google.com/?q=Bir+Uthman+Madinah',
          ),
        ],
      ),
    );
  }
}