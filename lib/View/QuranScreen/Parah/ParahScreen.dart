
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

import '../../../AllApiLink/AllApiLink.dart';
import '../../../Utils/Constants/AllImages.dart';
import '../../../Utils/Constants/userFeedback.dart';

class JuzModel {
  final int number;
  final String name;
  final String subname;

  JuzModel({required this.number, required this.name,required this.subname});
}
List<JuzModel> juzList = [
  JuzModel(number: 1, name: " آلم", subname:"Alif Lam Meem"),
  JuzModel(number: 2, name: "سَيَقُولُ",subname:"Sayaqool"),
  JuzModel(number: 3, name: "تِلْكَ ٱلْرُّسُلُ",subname:"Tilkal Rusul"),
  JuzModel(number: 4, name: " لَنْ تَنَالُوْ الْبِرَّ",subname:"Lan Tana Loo"),
  JuzModel(number: 5, name: " وَٱلْمُحْصَنَاتُ",subname: "Wal Mohsanat"),
  JuzModel(number: 6, name: " لَا يُحِبُّ ٱللهُ",subname:"La Yuhibbullah"),
  JuzModel(number: 7, name: "وَإِذَا سَمِعُوا",subname: "Wa Iza Samiu"),
  JuzModel(number: 8, name: "وَلَوْ أَنَّنَا",subname:"Wa Lau Annana"),
  JuzModel(number: 9, name: "قَالَ ٱلْمَلَأُ",subname:"Qalal Malao"),
  JuzModel(number: 10, name: "وَٱعْلَمُواْ",subname:"Wa A'lamu"),
  JuzModel(number: 11, name: "يَعْتَذِرُونَ",subname:"Yatazeroon"),
  JuzModel(number: 12, name: "وَمَا مِنْ دَآبَّةٍ",subname:"Wa Mamin Da'abat"),
  JuzModel(number: 13, name: "وَمَا أُبَرِّئُ",subname:"Wa Ma Ubarri"),
  JuzModel(number: 14, name: " رُبَمَا",subname:"Rubama"),
  JuzModel(number: 15, name: "سُبْحَانَ ٱلَّذِى",subname:"Subhanallazi"),
  JuzModel(number: 16, name: "قَالَ أَلَمْ",subname:"Qal Alam"),
  JuzModel(number: 17, name: "ٱقْتَرَبَ لِلْنَّاسِv",subname:"Iqtaraba"),
  JuzModel(number: 18, name: "قَدْ أَفْلَحَ",subname:"Qadd Aflaha"),
  JuzModel(number: 19, name: "وَقَالَ ٱلَّذِينَ",subname:"Wa Qalallazina"),
  JuzModel(number: 20, name: "أَمَّنْ خَلَقَ",subname:"A'man Khalaq"),
  JuzModel(number: 21, name: "أُتْلُ مَاأُوْحِیَ",subname: "Utlu Ma Oohi"),
  JuzModel(number: 22, name: "وَمَنْ يَّقْنُتْ",subname: "Wa Manyaqnut"),
  JuzModel(number: 23, name: "وَمَآ لي",subname:"Wa Mali"),
  JuzModel(number: 24, name: "فَمَنْ أَظْلَمُ",subname:"Faman Azlam"),
  JuzModel(number: 25, name: " إِلَيْهِ يُرَدُّ",subname:"Elahe Yuruddu"),
  JuzModel(number: 26, name: "حٰمٓ",subname:"Ha'a Meem"),
  JuzModel(number: 27, name: "قَالَ فَمَا خَطْبُكُمْ",subname:"Qala Fama Khatbukum"),
  JuzModel(number: 28, name: "قَدْ سَمِعَ ٱللهُ",subname:"Qadd Sami Allah"),
  JuzModel(number: 29, name: "تَبَارَكَ ٱلَّذِي",subname:"Tabarakallazi"),
  JuzModel(number: 30, name: "عَمَّ",subname:"Amma"),
];
class ParahCard extends StatelessWidget {
  final int index;
  final String name;
  final String subname;
  VoidCallback ontap;


  ParahCard({
    super.key,
    required this.index,
    required this.name,
    required this.subname,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: getHeight(8), ),
      child: InkWell(
        onTap: ontap,
        child: Row(
          children: [
            // Left vertical line
            Container(
              width: getWidth(6),
              height: getHeight(60),
              decoration: BoxDecoration(
                color: const Color(0xff5BC0BE),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
             SizedBox(width: getWidth(16)),

            // Card
            Expanded(
              child: Container(
                padding:  EdgeInsets.symmetric(
                  horizontal: getWidth(16), 
                  vertical: getHeight(14)
                  ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          AllImages.numcover,
                          height: getHeight(40),
                           width: getWidth(40)),
                        Text(
                          index.toString(),
                          style:  TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: getFont(12),
                          ),
                        ),
                      ],
                    ),
                     SizedBox(width: getWidth(16)),

                    // Name + Arabic Name

                          Expanded(
                            child: Text(
                              name,
                              style:AppColors().customTextStyle12(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)
                            ),
                          ),
                          Spacer(),
                          Text(
                            subname,
                            style: AppColors().customTextStyleAmiri22(color: Colors.black),
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
class JuzListScreen extends StatefulWidget {
  const JuzListScreen({super.key});

  @override
  State<JuzListScreen> createState() => _JuzListScreenState();
}

class _JuzListScreenState extends State<JuzListScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
        itemCount: juzList.length,
        itemBuilder: (context, index) {
          final juz = juzList[index];
return ParahCard(index: juz.number, name: juz.subname, subname: juz.name,ontap:  () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JuzDetailScreen(juz: juz),
          ),
        );
      },);

        },
      ),
    );
  }
}
class JuzDetailScreen extends StatefulWidget {
  final JuzModel juz;


  const JuzDetailScreen({super.key, required this.juz,});

  @override
  State<JuzDetailScreen> createState() => _JuzDetailScreenState();
}
class _JuzDetailScreenState extends State<JuzDetailScreen> {
  final QuranApiService apiService = QuranApiService();
  List<dynamic> ayahs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadJuz();
  }

  void loadJuz() async {
    final data = await apiService.fetchJuz(widget.juz.number);
    setState(() {
      ayahs = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         // centerTitle: true,
      title:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.juz.subname,
            style:  TextStyle(
              fontSize: getFont(18), 
              fontWeight: FontWeight.bold),
          ),
          Text(
            widget.juz.name,
            style:  TextStyle(
              fontSize: getFont(14),
              color: Color(0xff5BC0BE),
            ),
          ),
        ],
      ),
      //     title:
      // Text("${widget.juz.name}       ${widget.juz.number}",style: AppColors().customTextStyleAmiri14(color: Colors.black,fontWeight: FontWeight.bold),)
      ),
      body: isLoading
          ? Center(child: spinkit)
          : ListView.builder(
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          final ayah = ayahs[index];
          // Builder ke bahar ya build method ke start mein saari ayats ko join karein
          final paragraphText = ayahs.map((ayah) => ayah['text']).join(' ');

          return SingleChildScrollView( // Scroll karne ke liye
            padding:  EdgeInsets.all(16),
            child:


            Text(
              paragraphText,
              textAlign: TextAlign.right, // Arabic ke liye right align
              style: const TextStyle(
                fontSize: 22,
                height: 2.0, // Lines ke darmiyan space (behtar readability)
                // Agar koi custom font hai
              ),
            ),
          );
          // return Text(
          //   ayah['text'],
          //   textAlign: TextAlign.right,
          //   style: const TextStyle(fontSize: 20),
          // );
        },
      ),
    );
  }
}