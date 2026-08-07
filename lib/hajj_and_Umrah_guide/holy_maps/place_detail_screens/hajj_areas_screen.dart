import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class HajjAreasScreen extends StatelessWidget {
  const HajjAreasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Hajj Areas',
      imagePath: AllImages.hajjAreasbig,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Main Hajj Areas'),

          const NumberedHeading(number: 1, title: 'Masjid al-Haram'),
          const BoldLabel('Role', value: 'Starting and ending point of Hajj.'),
          const BoldLabel(
            'Rituals',
            value: 'Tawaf al-Qudum, Tawaf al-Ifadah, Tawaf al-Wada\', Sa\'i.',
          ),
          const MapLink(url: 'https://maps.google.com/?q=21.4225,39.8262'),

          const NumberedHeading(number: 2, title: 'Mina'),
          const BulletItem('Known as the City of Tents.'),
          const BulletItem(
            'Pilgrims stay here on 8th, 11th, 12th, and, if applicable, 13th Dhul Hijjah.',
          ),
          const BulletItem('Home to the Jamarat for the ritual of stoning.'),
          const MapLink(url: 'https://maps.google.com/?q=Mina+Makkah'),

          const NumberedHeading(number: 3, title: 'Mount Arafat'),
        ],
      ),
    );
  }
}