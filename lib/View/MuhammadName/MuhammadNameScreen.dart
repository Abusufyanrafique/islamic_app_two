import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

import '../../Utils/Constants/AllColors.dart';
import '../../Utils/Constants/AllImages.dart';


class MuhammadNameModel {
  final int index;
  final String englishName;
  final String arabicName;
  final String meaning;

  MuhammadNameModel({
    required this.index,
    required this.englishName,
    required this.arabicName,
    required this.meaning,
  });

  factory MuhammadNameModel.fromJson(Map<String, dynamic> json) {
    return MuhammadNameModel(
      index: json['index'],
      englishName: json['english_name'],
      arabicName: json['arabic_name'],
      meaning: json['meaning'],
    );
  }
}

final List<Map<String, dynamic>> namesJson = [
  {"index":1,"english_name":"Muhammad","arabic_name":"مُحَمَّدٌ","meaning":"The Praised One"},
  {"index":2,"english_name":"Ahmad","arabic_name":"أَحْمَدُ","meaning":"Highly Praised"},
  {"index":3,"english_name":"Hamid","arabic_name":"حَامِدٌ","meaning":"One who Praises"},
  {"index":4,"english_name":"Mahmud","arabic_name":"مَحْمُودٌ","meaning":"Praised One"},
  {"index":5,"english_name":"Mustafa","arabic_name":"مُصْطَفَى","meaning":"The Chosen One"},
  {"index":6,"english_name":"Mujtaba","arabic_name":"مُجْتَبَى","meaning":"Selected One"},
  {"index":7,"english_name":"Murtaza","arabic_name":"مُرْتَضَى","meaning":"Chosen and Accepted"},
  {"index":8,"english_name":"Taha","arabic_name":"طه","meaning":"Mystical Letters (Name of Prophet)"},
  {"index":9,"english_name":"Yasin","arabic_name":"يس","meaning":"Mystical Letters"},
  {"index":10,"english_name":"Abdullah","arabic_name":"عَبْدُ اللّٰهِ","meaning":"Servant of Allah"},

  {"index":11,"english_name":"Habibullah","arabic_name":"حَبِيبُ اللّٰهِ","meaning":"Beloved of Allah"},
  {"index":12,"english_name":"Rasulullah","arabic_name":"رَسُولُ اللّٰهِ","meaning":"Messenger of Allah"},
  {"index":13,"english_name":"Nabi","arabic_name":"نَبِيٌّ","meaning":"Prophet"},
  {"index":14,"english_name":"Shafi","arabic_name":"شَافِعٌ","meaning":"Intercessor"},
  {"index":15,"english_name":"Mahi","arabic_name":"مَاحٍ","meaning":"The Eraser (of disbelief)"},
  {"index":16,"english_name":"Hashir","arabic_name":"حَاشِرٌ","meaning":"Gatherer"},
  {"index":17,"english_name":"Aqib","arabic_name":"عَاقِبٌ","meaning":"The Last"},
  {"index":18,"english_name":"Fateh","arabic_name":"فَاتِحٌ","meaning":"The Conqueror"},
  {"index":19,"english_name":"Amin","arabic_name":"أَمِينٌ","meaning":"Trustworthy"},
  {"index":20,"english_name":"Sadiq","arabic_name":"صَادِقٌ","meaning":"Truthful"},

  {"index":21,"english_name":"Karim","arabic_name":"كَرِيمٌ","meaning":"Generous"},
  {"index":22,"english_name":"Rahim","arabic_name":"رَحِيمٌ","meaning":"Merciful"},
  {"index":23,"english_name":"Noor","arabic_name":"نُورٌ","meaning":"Light"},
  {"index":24,"english_name":"Siraj","arabic_name":"سِرَاجٌ","meaning":"Lamp"},
  {"index":25,"english_name":"Munir","arabic_name":"مُنِيرٌ","meaning":"Illuminating"},
  {"index":26,"english_name":"Bashir","arabic_name":"بَشِيرٌ","meaning":"Bearer of Good News"},
  {"index":27,"english_name":"Nazir","arabic_name":"نَذِيرٌ","meaning":"Warner"},
  {"index":28,"english_name":"Dai","arabic_name":"دَاعِي","meaning":"Caller to Allah"},
  {"index":29,"english_name":"Hadi","arabic_name":"هَادِي","meaning":"Guide"},
  {"index":30,"english_name":"Shahid","arabic_name":"شَهِيدٌ","meaning":"Witness"},

  {"index":31,"english_name":"Adil","arabic_name":"عَادِلٌ","meaning":"Just"},
  {"index":32,"english_name":"Hakim","arabic_name":"حَكِيمٌ","meaning":"Wise"},
  {"index":33,"english_name":"Sabir","arabic_name":"صَابِرٌ","meaning":"Patient"},
  {"index":34,"english_name":"Latif","arabic_name":"لَطِيفٌ","meaning":"Gentle"},
  {"index":35,"english_name":"Khabir","arabic_name":"خَبِيرٌ","meaning":"All-aware"},
  {"index":36,"english_name":"Basir","arabic_name":"بَصِيرٌ","meaning":"All-seeing"},
  {"index":37,"english_name":"Sami","arabic_name":"سَمِيعٌ","meaning":"All-hearing"},
  {"index":38,"english_name":"Ali","arabic_name":"عَلِيٌّ","meaning":"High"},
  {"index":39,"english_name":"Aziz","arabic_name":"عَزِيزٌ","meaning":"Mighty"},
  {"index":40,"english_name":"Jabbar","arabic_name":"جَبَّارٌ","meaning":"Compeller"},

  {"index":41,"english_name":"Ghaffar","arabic_name":"غَفَّارٌ","meaning":"Forgiving"},
  {"index":42,"english_name":"Wahhab","arabic_name":"وَهَّابٌ","meaning":"Bestower"},
  {"index":43,"english_name":"Razzaq","arabic_name":"رَزَّاقٌ","meaning":"Provider"},
  {"index":44,"english_name":"Fattah","arabic_name":"فَتَّاحٌ","meaning":"Opener"},
  {"index":45,"english_name":"Alim","arabic_name":"عَلِيمٌ","meaning":"All-knowing"},
  {"index":46,"english_name":"Qadir","arabic_name":"قَادِرٌ","meaning":"All-Powerful"},
  {"index":47,"english_name":"Wahid","arabic_name":"وَاحِدٌ","meaning":"One"},
  {"index":48,"english_name":"Samad","arabic_name":"صَمَدٌ","meaning":"Self-Sufficient"},
  {"index":49,"english_name":"Qayyum","arabic_name":"قَيُّومٌ","meaning":"Self-Subsisting"},
  {"index":50,"english_name":"Hayy","arabic_name":"حَيٌّ","meaning":"Ever-Living"},

  {"index":51,"english_name":"Haqq","arabic_name":"حَقٌّ","meaning":"Truth"},
  {"index":52,"english_name":"Wakil","arabic_name":"وَكِيلٌ","meaning":"Trustee"},
  {"index":53,"english_name":"Qawi","arabic_name":"قَوِيٌّ","meaning":"Strong"},
  {"index":54,"english_name":"Matin","arabic_name":"مَتِينٌ","meaning":"Firm"},
  {"index":55,"english_name":"Wali","arabic_name":"وَلِيٌّ","meaning":"Protector"},
  {"index":56,"english_name":"Hamid","arabic_name":"حَمِيدٌ","meaning":"Praiseworthy"},
  {"index":57,"english_name":"Majid","arabic_name":"مَجِيدٌ","meaning":"Glorious"},
  {"index":58,"english_name":"Raqib","arabic_name":"رَقِيبٌ","meaning":"Watchful"},
  {"index":59,"english_name":"Mujib","arabic_name":"مُجِيبٌ","meaning":"Responsive"},
  {"index":60,"english_name":"Wasi","arabic_name":"وَاسِعٌ","meaning":"All-encompassing"},

  {"index":61,"english_name":"Wadud","arabic_name":"وَدُودٌ","meaning":"Loving"},
  {"index":62,"english_name":"Baith","arabic_name":"بَاعِثٌ","meaning":"Resurrector"},
  {"index":63,"english_name":"Shaheed","arabic_name":"شَهِيدٌ","meaning":"Witness"},
  {"index":64,"english_name":"Muhsi","arabic_name":"مُحْصِي","meaning":"Enumerator"},
  {"index":65,"english_name":"Mubdi","arabic_name":"مُبْدِئ","meaning":"Originator"},
  {"index":66,"english_name":"Muid","arabic_name":"مُعِيدٌ","meaning":"Restorer"},
  {"index":67,"english_name":"Muhyi","arabic_name":"مُحْيِي","meaning":"Giver of Life"},
  {"index":68,"english_name":"Mumit","arabic_name":"مُمِيتٌ","meaning":"Creator of Death"},
  {"index":69,"english_name":"Wajid","arabic_name":"وَاجِدٌ","meaning":"Finder"},
  {"index":70,"english_name":"Kabir","arabic_name":"كَبِيرٌ","meaning":"Great"},

  {"index":71,"english_name":"Hafiz","arabic_name":"حَفِيظٌ","meaning":"Preserver"},
  {"index":72,"english_name":"Muqit","arabic_name":"مُقِيتٌ","meaning":"Sustainer"},
  {"index":73,"english_name":"Hasib","arabic_name":"حَسِيبٌ","meaning":"Reckoner"},
  {"index":74,"english_name":"Jalil","arabic_name":"جَلِيلٌ","meaning":"Majestic"},
  {"index":75,"english_name":"Karim","arabic_name":"كَرِيمٌ","meaning":"Generous"},
  {"index":76,"english_name":"Hakim","arabic_name":"حَكِيمٌ","meaning":"Wise"},
  {"index":77,"english_name":"Majid","arabic_name":"مَاجِدٌ","meaning":"Noble"},
  {"index":78,"english_name":"Qadir","arabic_name":"قَادِرٌ","meaning":"Powerful"},
  {"index":79,"english_name":"Muqtadir","arabic_name":"مُقْتَدِرٌ","meaning":"All Authoritative"},
  {"index":80,"english_name":"Samad","arabic_name":"صَمَدٌ","meaning":"Self-Sufficient"},

  {"index":81,"english_name":"Wahid","arabic_name":"وَاحِدٌ","meaning":"One"},
  {"index":82,"english_name":"Rahman","arabic_name":"رَحْمَٰنُ","meaning":"Most Merciful"},
  {"index":83,"english_name":"Rahim","arabic_name":"رَحِيمٌ","meaning":"Most Compassionate"},
  {"index":84,"english_name":"Noor","arabic_name":"نُورٌ","meaning":"Light"},
  {"index":85,"english_name":"Siraj","arabic_name":"سِرَاجٌ","meaning":"Lamp"},
  {"index":86,"english_name":"Munir","arabic_name":"مُنِيرٌ","meaning":"Illuminating"},
  {"index":87,"english_name":"Bashir","arabic_name":"بَشِيرٌ","meaning":"Bringer of Good News"},
  {"index":88,"english_name":"Nazir","arabic_name":"نَذِيرٌ","meaning":"Warner"},
  {"index":89,"english_name":"Hadi","arabic_name":"هَادِي","meaning":"Guide"},
  {"index":90,"english_name":"Shafi","arabic_name":"شَافِعٌ","meaning":"Intercessor"},

  {"index":91,"english_name":"Amin","arabic_name":"أَمِينٌ","meaning":"Trustworthy"},
  {"index":92,"english_name":"Sadiq","arabic_name":"صَادِقٌ","meaning":"Truthful"},
  {"index":93,"english_name":"Karim","arabic_name":"كَرِيمٌ","meaning":"Generous"},
  {"index":94,"english_name":"Rahim","arabic_name":"رَحِيمٌ","meaning":"Merciful"},
  {"index":95,"english_name":"Latif","arabic_name":"لَطِيفٌ","meaning":"Gentle"},
  {"index":96,"english_name":"Khabir","arabic_name":"خَبِيرٌ","meaning":"All-aware"},
  {"index":97,"english_name":"Basir","arabic_name":"بَصِيرٌ","meaning":"All-seeing"},
  {"index":98,"english_name":"Sami","arabic_name":"سَمِيعٌ","meaning":"All-hearing"},
  {"index":99,"english_name":"Ali","arabic_name":"عَلِيٌّ","meaning":"High"}

];

final List<MuhammadNameModel> namesList =
namesJson.map((e) => MuhammadNameModel.fromJson(e)).toList();

class MuhammadNameScreen extends StatelessWidget {
  const MuhammadNameScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
       elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "99 Names of Muhammad ﷺ",
           style: AppColors().customTextStyleBold16(
              color:AppColors.black )
        ),
        centerTitle: true,
         bottom: PreferredSize(
    preferredSize: const Size.fromHeight(0.12),
    child: Container(
      color: const Color(0xFF6B7678),
      height: 0.12,
    ),
  ),
      ),
      body:  Column(
        children: [
          Container(
            width: double.infinity,
            margin:  EdgeInsets.all(16),
            padding:  EdgeInsets.symmetric(
                vertical: getHeight(20), 
                horizontal: getWidth(16)),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff5BC0BE), Color(0xff3A9E9C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children:  [
                Text(
                  "أَسْمَاءُ النَّبِيِّ مُحَمَّدٍ ﷺ",
                  style: TextStyle(
                    fontSize: getFont(26),
                    color: Colors.white,
                    fontFamily: 'Amiri',
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: getHeight(8)),
                Text(
                  "Names of Prophet Muhammad ﷺ",
                   style: AppColors().customTextStyleBold16(
                      color:AppColors.white )
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
            //  padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: namesList.length,
              itemBuilder: (context, index) {
                final item = namesList[index];
                return MuhammadNameCard(
                  index: item.index,
                   name: item.englishName, 
                   meaning: item.meaning,
                    arabicname: item.arabicName);
              },
            ),
          ),
        ],
      ),

    );
  }
}

class MuhammadNameCard extends StatelessWidget {
  final int index;
  final String name;
  final String meaning;
  final String arabicname;

  const MuhammadNameCard({
    super.key, 
    required this.index, 
    required this.name, 
    required this.meaning, 
    required this.arabicname
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: getHeight(8), 
        horizontal: getWidth(16)),

      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: getWidth(6),

              decoration: BoxDecoration(
                color: const Color(0xff5BC0BE),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
             SizedBox(width: getWidth(12)),

            // Card
            Expanded(
              child: Container(
                padding:  EdgeInsets.symmetric(
                  horizontal: getWidth(16), 
                  vertical: getHeight(14)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // Number with image background
                    Stack(
                      alignment: Alignment.center,
                      children: [

                        SvgPicture.asset(AllImages.numcover),
                        Text(
                          index.toString(),
                          style: 
                           TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getFont(14),
                          ),
                        ),
                      ],
                    ),
                     SizedBox(width: getWidth(16)),

                    // Book Name + Writer info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style:AppColors().customTextStyleBold16().copyWith(
                              fontSize: getFont(14)
                            )
                            
                          ),
                           SizedBox(height: getHeight(4)),
                          Text(
                            meaning,
                            style: AppColors().customTextStyle12(
                            ).copyWith(
                              fontSize: getFont(12)
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Hadith Count
                    Text(
                      arabicname,
                      style:  TextStyle(
                        fontSize: getFont(22),
                        color: Color(0xff5BC0BE),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Amiri',
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}