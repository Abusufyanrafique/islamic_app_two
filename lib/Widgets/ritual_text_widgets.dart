import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';


class RitualTitle extends StatelessWidget {
  final String text;
  const RitualTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getHeight(16)),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style:AppColors().customTextStyle20(
            color: AppColors.labbaik
          ).copyWith(
            fontSize: getFont(26)
          )
        ),
      ),
    );
  }
}

/// Large centered Arabic dua/verse text
class ArabicVerse extends StatelessWidget {
  final String text;
  const ArabicVerse(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getHeight(16)),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style:AppColors().customTextStyle18().copyWith(
            fontSize: getFont(22)
          )
        ),
      ),
    );
  }
}


class RitualHeading extends StatelessWidget {
  final String text;
  const RitualHeading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: getHeight(12), 
        bottom: getHeight(6),
        ),
      child: Text(
        text,
        style:AppColors().customTextStyle18().copyWith(
          height: 1.3,
        )
      ),
    );
  }
}


class RitualStepHeading extends StatelessWidget {
  final String text;
  const RitualStepHeading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getHeight(8), bottom: getHeight(4)),
      child: Text(
        text,
        style:AppColors().customTextStyle18().copyWith(
          height: 1.3,
        ) 
      ),
    );
  }
}

/// Plain body paragraph text
class RitualBodyText extends StatelessWidget {
  final String text;
  const RitualBodyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: getHeight(6)),
      child: Text(
        text,
       style:AppColors().customTextStyle14().copyWith(
        height: 1.3, 
       ) 
      ),
    );
  }
}

class RitualEmojiBulletItem extends StatelessWidget {
  final String emoji;
  final String text;

  const RitualEmojiBulletItem({
    super.key,
    required this.emoji,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getHeight(4), 
        left: getWidth(4),
        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$emoji  ', style: TextStyle(
            fontSize: getFont(14),
            )),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: getFont(14), 
                color: AppColors.black, 
                height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}


class RitualBulletItem extends StatelessWidget {
  final String text;
  const RitualBulletItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getHeight(4), 
        left: getWidth(4),
        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ',
           style: TextStyle(
            fontSize: getFont(14), 
            color: AppColors.black,
            )),
          Expanded(
            child: Text(
              text,
              style:AppColors().customTextStyle14().copyWith(
                height: 1.3,
              ).copyWith(
                // fontSize: getFont(24)
              )
            ),
          ),
        ],
      ),
    );
  }
}


class RitualCheckItem extends StatelessWidget {
  final String text;
  const RitualCheckItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getHeight(4), 
        left: getWidth(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check, 
            size: getFont(16), 
            color: AppColors.black,
            ),
          SizedBox(width: getWidth(6)),
          Expanded(
            child: Text(
              text,
             style:AppColors().customTextStyle14() 
            ),
          ),
        ],
      ),
    );
  }
}


class ArabicTransliterationTranslation extends StatelessWidget {
  final String arabic;
  final String transliteration;
  final String translation;

  const ArabicTransliterationTranslation({
    super.key,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RitualHeading('Arabic'),
        Padding(
          padding: EdgeInsets.only(bottom: getHeight(8)),
          child: Text(
            arabic,
            textDirection: TextDirection.rtl,
            style: AppColors().customTextStyle18()
          ),
        ),
        RitualHeading('Transliteration'),
        Padding(
          padding: EdgeInsets.only(bottom: getHeight(8)),
          child: Text(
            transliteration,
            style: AppColors().customTextStyle18()
          ),
        ),
        RitualHeading('Translation'),
        Padding(
          padding: EdgeInsets.only(bottom: getHeight(8)),
          child: Text(
            '"$translation"',
            style: AppColors().customTextStyle14()
          ),
        ),
      ],
    );
  }
}