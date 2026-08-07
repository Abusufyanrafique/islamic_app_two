import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class FloatingMosqueScreen extends StatelessWidget {
  const FloatingMosqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'floating Mosque',
      imagePath: AllImages.floatingmosque,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Al Rahma Mosque (Floating Mosque)'),

          const BulletItem("One of Jeddah's best-known\n mosques."),
          const BulletItem('A popular place for prayer and\n reflection before or after Hajj and\n Umrah.'),
          const BulletItem(
            'Google Maps: https://maps.google.com/?q=Al+Rahma+Mosque+Jeddahah',
            linkUrl: 'https://maps.google.com/?q=Al+Rahma+Mosque+Jeddahah',
          ),
        ],
      ),
    );
  }
}