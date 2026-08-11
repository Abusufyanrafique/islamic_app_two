import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final Widget content;

  const PlaceDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: AppColors.black,
            ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          title,
          style: AppColors().customTextStyle15().copyWith(
            fontSize: getFont(16),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(16),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: getHeight(8)),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width:getWidth(370),
                height: getHeight(233),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: getHeight(16)),
            content,
            SizedBox(height: getHeight(24)),
          ],
        ),
      ),
    );
  }
}

/// Big section title, e.g. "Historic Wells of Makkah"
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getHeight(8), 
        top: getHeight(4),
        ),
      child: Text(
        text,
        style:AppColors().customTextStyle20().copyWith(
          height: 1.3
        )
      ),
    );
  }
}

class BoldLabel extends StatelessWidget {
  final String label;
  final String? value;
  const BoldLabel(
    this.label, {
      this.value,
       super.key,
       });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: getHeight(4)),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: getFont(14),
             color: AppColors.black,
             ),
          children: [
            TextSpan(
              text: value == null ? label : '$label: ',
              style:AppColors().customTextStyle20().copyWith(
                fontSize: getFont(16)
              )
            ),
            if (value != null) TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

/// Clickable Google Maps (or any) link — bold label + blue underlined url
class MapLink extends StatelessWidget {
  final String label;
  final String url;

  const MapLink({super.key, this.label = 'Google Maps: ', required this.url});

  Future<void> _openLink() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: getHeight(8)),
      child: GestureDetector(
        onTap: _openLink,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: getFont(14), 
              color: AppColors.black,
              ),
            children: [
              TextSpan(
                text: label,
               style:AppColors().customTextStyle24().copyWith(
                fontSize: getFont(16)
               )
              ),
              TextSpan(
                text: url,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Plain paragraph text
class BodyText extends StatelessWidget {
  final String text;
  const BodyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: getHeight(8)),
      child: Text(
        text,
        style:AppColors().customTextStyle14().copyWith(
          fontSize: getFont(16),
          height: 1.3
        )
      ),
    );
  }
}


class BulletItem extends StatelessWidget {
  final String text;
  final String? linkUrl;

  const BulletItem(this.text, {this.linkUrl, super.key});

  Future<void> _openLink() async {
    if (linkUrl == null) return;
    final uri = Uri.parse(linkUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: getHeight(6), left: getWidth(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ',
              style: TextStyle(fontSize: getFont(14), color: AppColors.black)),
          Expanded(
            child: linkUrl == null
                ? Text(
                    text,
                    style:AppColors().customTextStyle14().copyWith(
                   fontSize: getFont(16),
                   height: 1.3,
                  )
                  )
                : GestureDetector(
                    onTap: _openLink,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: getFont(14),
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        height: 1.4,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Numbered heading e.g. "1. Masjid al-Haram"
class NumberedHeading extends StatelessWidget {
  final int number;
  final String title;
  const NumberedHeading({super.key, required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getHeight(12), bottom: getHeight(6)),
      child: Text(
        '$number. $title',
        style: TextStyle(
          fontSize: getFont(16),
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
    );
  }
}