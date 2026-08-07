import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class CemetriesScreen extends StatelessWidget {
  const CemetriesScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Cemetries',
      imagePath: AllImages.cemetriesbig,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BoldLabel('Location', value: 'North of Masjid al-Haram, Makkah'),
          const MapLink(url: 'https://maps.google.com/?q=Jannat+al+Mualla+Makkah'),
          SizedBox(height: getHeight(12)),
          const SectionTitle('Other Cemeteries in Makkah'),

          const BoldLabel('Al-Shubaika Cemetery'),
          const BodyText(
            'Al-Shubaika Cemetery is one of the historic cemeteries in Makkah, '
            'located close to the western side of Masjid al-Haram.',
          ),
          const BulletItem(
            'Google Maps: https://maps.google.com/?q=Al+Shubaika+Cemetery+Makkah',
            linkUrl: 'https://maps.google.com/?q=Al+Shubaika+Cemetery+Makkah',
          ),
          const BulletItem('Historic cemetery near Masjid al-Haram.'),
          SizedBox(height: getHeight(8)),

          const BoldLabel('Al Adl Cemetery'),
          const BodyText(
            "Al Adl Cemetery is one of the largest public cemeteries in Makkah. "
            "It serves as a major burial ground for the city's residents and is "
            "still actively used today.",
          ),
          const BulletItem(
            'Google Maps: https://maps.google.com/?q=Al+Adl+Cemetery+Makkah',
            linkUrl: 'https://maps.google.com/?q=Al+Adl+Cemetery+Makkah',
          ),
          const BulletItem('Large modern public cemetery.'),
          SizedBox(height: getHeight(8)),

          const BoldLabel('Al Sharai Cemetery'),
        ],
      ),
    );
  }
}