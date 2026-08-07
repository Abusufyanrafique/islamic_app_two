import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class RayadUlJannahScreen extends StatelessWidget {
  const RayadUlJannahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Rayad ul Jannah',
      imagePath: AllImages.riyadulJannah,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Rayad ul Jannah'),

          const BulletItem('📍 Located inside Al-\nMasjid an-Nabawi.'),
          const BulletItem('Known as Riyad al-Jannah\n (Garden of Paradise).'),
          const BulletItem('One of the most blessed places to\n offer voluntary prayers.'),
          const MapLink(
            url: 'https://maps.google.com/?q=Rawdah+Madinah',
          ),
        ],
      ),
    );
  }
}