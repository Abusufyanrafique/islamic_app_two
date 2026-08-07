import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class InternationalAirportScreen extends StatelessWidget {
  const InternationalAirportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'International Airport',
      imagePath: AllImages.kingAirport,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('King Abdulaziz\n International Airport – Hajj \nTerminal'),

          const BulletItem('The main arrival point for millions of\n Hajj and Umrah pilgrims.'),
          const BulletItem(
            'Specially designed to \naccommodate large numbers of pilgrims with '
            'dedicated \nimmigration and transport facilities.',
          ),

          const BoldLabel('Google Maps'),
          const MapLink(
            label: '',
            url: 'https://maps.google.com/?q=King+Abdulaziz+International+Airport+Jeddah',
          ),
        ],
      ),
    );
  }
}