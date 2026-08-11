import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/jeddah_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/madina_screen.dart';
import 'package:local_notification/hajj_and_Umrah_guide/holy_maps/makkah_screen.dart';

class HolyMapsScreen extends StatelessWidget {
  const HolyMapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(16),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: getHeight(8)),
            const HolySearchBar(),
            SizedBox(height: getHeight(20)),
            Expanded(child: _buildPlacesGrid(context)),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        AllText.holymaps,
       style:AppColors().customTextStyleBold16().copyWith(
            fontSize: getFont(16),
          )
      ),
    );
  }

  Widget _buildPlacesGrid(BuildContext context) {
    final places = HolyPlacesData.places;

    return GridView.builder(
      itemCount: places.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final place = places[index];
        return HolyPlaceCard(
          place: place,
          onTap: () => _onPlaceTap(context, place),
        );
      },
    );
  }

  /// Centralized navigation logic — context is available here.
  void _onPlaceTap(BuildContext context, HolyPlace place) {
    switch (place.title) {
      case 'Makkah':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MakkahScreen()),
        );
        break;
      case 'Madina':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MadinaScreen()),
        );
        break;
      case 'Jeddah':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JeddahScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on ${place.title}')),
        );
    }
  }
}

class HolyPlaceCard extends StatelessWidget {
  final HolyPlace place;
  final VoidCallback? onTap;

  const HolyPlaceCard({
    super.key,
    required this.place,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.black.withOpacity(0.10),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(12),
                vertical: getHeight(3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(),
                  SizedBox(height: getHeight(2)),
                  _buildSubtitle(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Image.asset(
        place.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.hinttext,
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(place.title, style: AppColors().customTextStyleBold16()),
       
        Spacer(),
        const Icon(
          Icons.chevron_right,
          size: 18,
          color: AppColors.black,
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Text(
      place.subtitle,
      style: AppColors().customTextStyle14().copyWith(
        fontSize: getFont(12)
      )
    );
  }
}

class HolyPlace {
  final String title;
  final String subtitle;
  final String imageUrl;

  const HolyPlace({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class HolyPlacesData {
  static const List<HolyPlace> places = [
    HolyPlace(
      title: 'Makkah',
      subtitle: 'The Holy City',
      imageUrl: AllImages.makkahimage,
    ),
    HolyPlace(
      title: 'Madina',
      subtitle: 'The Holy Mosque',
      imageUrl: AllImages.madinaimage,
    ),
    HolyPlace(
      title: 'Jeddah',
      subtitle: 'Gateway to Holy Cities',
      imageUrl: AllImages.jeddahimage,
    ),
  ];
}

class HolySearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onMenuTap;
  final ValueChanged<String>? onChanged;

  const HolySearchBar({
    super.key,
    this.hintText = 'Hinted search text',
    this.onMenuTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(52),
      decoration: BoxDecoration(
        color: AppColors.labbaik,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: AppColors.white),
            onPressed: onMenuTap,
          ),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppColors().customTextStyle14(
                  color: AppColors.white,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: getWidth(16)),
            child: Icon(Icons.search, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}