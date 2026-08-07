import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class QubaMosqueScreen extends StatelessWidget {
  const QubaMosqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Quba Mosque',
      imagePath: AllImages.masjideQuba,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Quba Mosque'),

          const BulletItem('About 3.5 km south of Al-Masjid\n an-Nabawi.'),
          const BulletItem('The first mosque built in Islam.'),
          const MapLink(
            url: 'https://maps.google.com/?q=Quba+Mosque+Madinah',
          ),
        ],
      ),
    );
  }
}