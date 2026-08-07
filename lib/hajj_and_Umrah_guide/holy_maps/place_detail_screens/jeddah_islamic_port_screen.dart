import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class JeddahIslamicPortScreen extends StatelessWidget {
  const JeddahIslamicPortScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Jeddah Islamic Port',
      imagePath: AllImages.jeddahIslamicPort,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Jeddah Islamic Port'),

          const BodyText(
            'Historically the principal seaport where\n pilgrims from around '
            'the world arrived \nbefore traveling to Makkah.',
          ),
          const BodyText('Played a central role in Hajj travel for centuries.'),

          const BoldLabel('Google Maps'),
          const MapLink(
            label: '',
            url: 'https://maps.google.com/?q=Jeddah+Islamic+Port',
          ),
        ],
      ),
    );
  }
}