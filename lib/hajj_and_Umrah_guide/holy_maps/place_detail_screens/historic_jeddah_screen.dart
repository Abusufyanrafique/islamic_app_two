import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class HistoricJeddahScreen extends StatelessWidget {
  const HistoricJeddahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Historic Jeddah',
      imagePath: AllImages.historicJeddah,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Historic Jeddah (Al-Balad)'),

          const BulletItem('A UNESCO World Heritage Site.'),
          const BulletItem(
            'For centuries, pilgrims arriving by sea passed through Al-Balad '
            'before continuing to Makkah.',
          ),
          const BulletItem(
            'Today, the Historic Hajj Route recreates this traditional '
            'pilgrimage journey.',
          ),

          const BoldLabel('Google Maps'),
          const MapLink(
            label: '',
            url: 'https://maps.google.com/?q=Historic+Jeddah+Al+Balad',
          ),
        ],
      ),
    );
  }
}