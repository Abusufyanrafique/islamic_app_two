import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/place_detail_screens/place_detail_screen.dart';


class MuseumScreen extends StatelessWidget {
  const MuseumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceDetailScreen(
      title: 'Musuem',
      imagePath: AllImages.musa,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Museums of Makkah'),
          const NumberedHeading(
            number: 1,
            title: "International Museum of the \nProphet's Biography",
          ),
          const BodyText('Life of Prophet Muhammad ﷺ.'),
          const BodyText('More than 30 exhibition halls and 200+\n interactive displays.'),
          const BodyText('Available in multiple languages.'),
          const BulletItem(
            "Google Maps: https://maps.google.com/?q=International+Museum+of+the+Prophet%27s+Biography+Makkah",
            linkUrl:
                "https://maps.google.com/?q=International+Museum+of+the+Prophet%27s+Biography+Makkah",
          ),

          const NumberedHeading(number: 2, title: 'Clock Tower Museum'),
          const BodyText('Astronomy and timekeeping.'),
          const BodyText('History of the Makkah Clock Tower.'),
          const BodyText('Observation decks with panoramic\n views of Masjid al-Haram.'),
          const BulletItem(
            'Google Maps: https://maps.google.com/?q=Clock+Tower+Museum+Makkah',
            linkUrl: 'https://maps.google.com/?q=Clock+Tower+Museum+Makkah',
          ),
        ],
      ),
    );
  }
}