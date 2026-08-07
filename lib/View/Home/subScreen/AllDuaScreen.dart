import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/services/audio_service/audio_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Utils/Constants/AllColors.dart';
import '../../../Utils/Constants/AllImages.dart';
import '../../../Utils/Constants/SizeConfig.dart';
import 'SubjectWiseDuaScreen.dart';

class DuaModel {
  final String arabic;
  final String urdu;
  final String english;
  final String reference;

  DuaModel({
    required this.arabic,
    required this.urdu,
    required this.english,
    required this.reference,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      arabic: json['arabic'] ?? "",
      urdu: json['urdu'] ?? "",
      english: json['english'] ?? "",
      reference: json['reference'] ?? "", 
    );
  }
}

final List<DuaModel> namesList = duasJson
    .map((e) => DuaModel.fromJson(e))
    .toList();
final List<Map<String, dynamic>> duasJson = [
  {
    "index": 1,
    "arabic": "رَبِّ زِدْنِي عِلْمًا",
    "urdu": "اے میرے رب! میرے علم میں اضافہ فرما",
    "english": "O my Lord, increase my knowledge",
    "reference": "📖 Surah Taha (20:114)",
  },
  {
    "index": 2,
    "arabic": "رَبِّ اغْفِرْ لِي",
    "urdu": "اے میرے رب! مجھے بخش دے",
    "english": "O my Lord, forgive me",
    "reference": "📖 Surah Nuh (71:28)",
  },
  {
    "index": 3,
    "arabic": "اللَّهُمَّ ارْحَمْنِي",
    "urdu": "اے اللہ! مجھ پر رحم فرما",
    "english": "O Allah, have mercy on me",
    "reference": "📖 Hadith — Sahih Muslim",
  },
  {
    "index": 4,
    "arabic": "حَسْبِيَ اللَّهُ",
    "urdu": "اللہ میرے لیے کافی ہے",
    "english": "Allah is enough for me",
    "reference": "📖 Surah Tawbah (9:129)",
  },
  {
    "index": 5,
    "arabic": "رَبِّ اهْدِنِي",
    "urdu": "اے میرے رب! مجھے ہدایت دے",
    "english": "O my Lord, guide me",
    "reference": "📖 Surah Al-Fatihah (1:6)",
  },
  {
    "index": 6,
    "arabic": "رَبِّ انصُرْنِي",
    "urdu": "اے میرے رب! میری مدد فرما",
    "english": "O my Lord, help me",
    "reference": "📖 Surah Al-Qasas (28:21)",
  },
  {
    "index": 7,
    "arabic": "رَبِّ يَسِّرْ",
    "urdu": "اے میرے رب! آسانی عطا فرما",
    "english": "O my Lord, make things easy for me",
    "reference": "📖 Surah Taha (20:26)",
  },
  {
    "index": 8,
    "arabic": "رَبِّ تَقَبَّلْ مِنِّي",
    "urdu": "اے میرے رب! میری عبادت قبول فرما",
    "english": "O my Lord, accept from me",
    "reference": "📖 Surah Al-Baqarah (2:127)",
  },
  {
    "index": 9,
    "arabic": "رَبِّ لَا تُزِغْ قَلْبِي",
    "urdu": "اے میرے رب! میرا دل سیدھا رکھ",
    "english": "O my Lord, do not let my heart go astray",
    "reference": "📖 Surah Aal-e-Imran (3:8)",
  },
  {
    "index": 10,
    "arabic": "رَبِّ ارْحَمْهُمَا",
    "urdu": "اے میرے رب! میرے والدین پر رحم فرما",
    "english": "O my Lord, have mercy on my parents",
    "reference": "📖 Surah Al-Isra (17:24)",
  },
  {
    "index": 11,
    "arabic": "رَبِّ أَعُوذُ بِكَ",
    "urdu": "اے میرے رب! میں تیری پناہ مانگتا ہوں",
    "english": "O my Lord, I seek refuge in You",
    "reference": "📖 Surah Al-Muminun (23:97-98)",
  },
  {
    "index": 12,
    "arabic": "رَبِّ نَجِّنِي",
    "urdu": "اے میرے رب! مجھے نجات دے",
    "english": "O my Lord, save me",
    "reference": "📖 Surah Al-Anbiya (21:87)",
  },
  {
    "index": 13,
    "arabic": "رَبِّ اشْرَحْ لِي صَدْرِي",
    "urdu": "اے میرے رب! میرا سینہ کھول دے",
    "english": "O my Lord, open my chest for me",
    "reference": "📖 Surah Taha (20:25)",
  },
  {
    "index": 14,
    "arabic": "رَبِّ سَلِّمْ",
    "urdu": "اے میرے رب! مجھے سلامتی دے",
    "english": "O my Lord, grant me peace and safety",
    "reference": "📖 Hadith — Abu Dawud",
  },
  {
    "index": 15,
    "arabic": "رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ",
    "urdu": "اے میرے رب! مجھے نماز قائم کرنے والا بنا",
    "english": "O my Lord, make me one who establishes prayer",
    "reference": "📖 Surah Ibrahim (14:40)",
  },
  {
    "index": 16,
    "arabic": "اللَّهُمَّ اغْفِرْ لِي",
    "urdu": "اے اللہ! مجھے بخش دے",
    "english": "O Allah, forgive me",
    "reference": "📖 Hadith — Sahih Bukhari",
  },
  {
    "index": 17,
    "arabic": "اللَّهُمَّ اهْدِنِي",
    "urdu": "اے اللہ! مجھے ہدایت دے",
    "english": "O Allah, guide me",
    "reference": "📖 Hadith — Sahih Muslim",
  },
  {
    "index": 18,
    "arabic": "اللَّهُمَّ عَافِنِي",
    "urdu": "اے اللہ! مجھے صحت دے",
    "english": "O Allah, grant me good health",
    "reference": "📖 Hadith — Tirmidhi",
  },
  {
    "index": 19,
    "arabic": "اللَّهُمَّ ارْزُقْنِي",
    "urdu": "اے اللہ! مجھے رزق عطا فرما",
    "english": "O Allah, provide me with sustenance",
    "reference": "📖 Hadith — Ibn Majah",
  },
  {
    "index": 20,
    "arabic": "اللَّهُمَّ ثَبِّتْ قَلْبِي",
    "urdu": "اے اللہ! میرے دل کو مضبوط رکھ",
    "english": "O Allah, keep my heart firm and strong",
    "reference": "📖 Hadith — Sahih Muslim",
  },
];

// --- Events ---
abstract class AllDuaEvent {}
class ChangeTabEvent extends AllDuaEvent {
  final int index;
  ChangeTabEvent(this.index);
}
// --- State ---
class AllDuaState {
  final int selectedIndex;
  AllDuaState({this.selectedIndex = 0});
}
// --- BLoC ---
class AllDuaBloc extends Bloc<AllDuaEvent, AllDuaState> {
  AllDuaBloc() : super(AllDuaState()) {
    on<ChangeTabEvent>((event, emit) {
      emit(AllDuaState(selectedIndex: event.index));
    });
  }
}
class AllDuaScreen extends StatelessWidget {
  const  AllDuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        title:  Text(
          "All Dua",
          style: TextStyle(
            color: Colors.white,
             fontWeight: FontWeight.bold,
             ),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: getWidth(16),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: getHeight(10)),
            const Text("Quick Access"),
             SizedBox(height: getHeight(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 QuickAccessContainer(
                  heading: "Dua of the Day",
                  subheading: "Daily dua quick access",
                  isSelected: true,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookmarksScreen()),
                  ),
                  child:  QuickAccessContainer(
                    heading: "Bookmarks",
                    subheading: "Saved Duas",
                  ),
                ),
              ],
            ),
             SizedBox(height: getHeight(20)),

            
            BlocBuilder<AllDuaBloc, AllDuaState>(
              builder: (context, state) {
                return allduaContainer(
                  heading: "All Dua",
                  subheading: "Subject Wise",
                  selectedIndex: state.selectedIndex,
                  onTap: (index) {
                    context.read<AllDuaBloc>().add(ChangeTabEvent(index));
                  },
                );
              },
            ),

             SizedBox(height: getHeight(16)),

            Expanded(
              child: BlocBuilder<AllDuaBloc, AllDuaState>(
                builder: (context, state) {
                  return state.selectedIndex == 0
                      ? ListView.builder(
                    itemCount: namesList.length,
                    itemBuilder: (context, index) {
                      final dua = namesList[index];
                      return Padding(
                        padding:  EdgeInsets.symmetric(
                          vertical: getHeight(8)),
                        child: AllDuaCard(dua: dua),
                      );
                    },
                  )
                      : const SubjectsScreen();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class AllDuaCard extends StatelessWidget {
  final DuaModel? dua;
  final bool showLeftLine;

  const AllDuaCard({
    super.key,
    this.dua,
    this.showLeftLine = true,
  });

  @override
  Widget build(BuildContext context) {
    // Pick a random dua if none provided
    final selectedDua = dua ?? namesList[Random().nextInt(namesList.length)];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showLeftLine)
            Container(
              width: getWidth(6),
              decoration: BoxDecoration(
                color: const Color(0xff5BC0BE),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          if (showLeftLine) SizedBox(
            width: getWidth(12),),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(16),
                vertical: getHeight(14),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                     blurRadius: 6),
                ],
              ),
              child: Column(
                children: [
                  // Top action bar
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidth(12),
                      ),
                    height: getHeight(38),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final shareText = '''
                            ${selectedDua.arabic}
                            ${selectedDua.english}
                            ${selectedDua.urdu}
                           Reference: ${selectedDua.reference} ''';
                            Share.share(shareText);
                          },
                          child: SvgPicture.asset('assets/icons/Group.svg'),
                        ),
                        SizedBox(width: getWidth(10)),
                        // Play / Stop (TTS) button
                        ValueListenableBuilder<String?>(
                        valueListenable: AudioService.instance.currentlySpeaking,
                        builder: (context, speakingId, _) {
                        final isThisPlaying = speakingId == selectedDua.arabic;
                        return GestureDetector(
                        onTap: () {
                        debugPrint("Current: $speakingId");
                        AudioService.instance.speakOrToggle(
                        selectedDua.arabic,
                        selectedDua.arabic,
                        );
                        },
                       child: Icon(
                       isThisPlaying ? Icons.stop_circle : Icons.play_circle_fill,
                       color: AppColors.primaryColor,
                       size: 28,
      ),
    );
  },
),
                      ],
                    ),
                  ),
                  SizedBox(height: getHeight(10)),
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            AllImages.numcover,
                            height: getHeight(40),
                            width: getWidth(40),
                          ),
                          Text(
                            (namesList.indexOf(selectedDua) + 1).toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: getFont(12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: getWidth(16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedDua.english,
                              style: TextStyle(
                                fontSize: getFont(9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: getHeight(4)),
                            Text(
                              selectedDua.urdu,
                              style: TextStyle(fontSize: getFont(10), color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        selectedDua.arabic,
                        style: TextStyle(
                          fontSize: getFont(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class QuickAccessContainer extends StatelessWidget {
  final String heading;
  final String subheading;
  final bool isSelected;
  final Color primaryColor;

  QuickAccessContainer({
    super.key,
    required this.heading,
    required this.subheading,
    this.isSelected = false,
    this.primaryColor = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(
        horizontal: getWidth(10),
       vertical: getHeight(5)),
      height: getHeight(45),
      width: getWidth(180),


      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isSelected ? primaryColor : Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: getFont(10),
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          Text(
            subheading,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: getFont(10),
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
class allduaContainer extends StatelessWidget {
  final String heading;

  final String subheading;
  final int selectedIndex;
  final Function(int) onTap;

  allduaContainer({
    super.key,
    required this.heading,
    required this.subheading,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: getHeight(45),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          // All Dua Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  // color: selectedIndex == 0
                  //     ? Colors.white          // ← selected = white background
                  //     : Colors.transparent,   // ← unselected = transparent
                  borderRadius: BorderRadius.circular(50),
                  border: selectedIndex == 0
                      ? Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ) // ← selected border
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  heading,
                  style: AppColors().customTextStyle12(
                    fontWeight: selectedIndex == 0
                        ? FontWeight
                              .w700 // ← selected bold
                        : FontWeight.w500,
                    color: Colors.white,
                    // color: selectedIndex == 0
                    //     ? AppColors.black   // ← selected dark text
                    //     : Colors.white,    // ← unselected white text
                  ),
                ),
              ),
            ),
          ),

          // Subject Wise Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(1),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  // color: selectedIndex == 1
                  // ? Colors.white
                  // : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: selectedIndex == 1
                      ? Border.all(color: Colors.white, width: 1)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  subheading,
                  style: AppColors().customTextStyle12(
                    fontWeight: selectedIndex == 1
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: Colors.white,
                    // color: selectedIndex == 1
                    //     ? AppColors.black
                    //     : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class Dua {
  final String label;
  final Color labelBg;
  final Color labelColor;
  final String arabic;
  final String urdu;
  final String translation;

  const Dua({
    required this.label,
    required this.labelBg,
    required this.labelColor,
    required this.arabic,
    required this.urdu,
    required this.translation,
  });
}

class DuaCard extends StatelessWidget {
  final Dua dua;
  const DuaCard({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      padding:  EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label badge
          Container(
            padding:  EdgeInsets.symmetric(
              horizontal: getWidth(10), 
              vertical: getHeight(4)),
            decoration: BoxDecoration(
              color: dua.labelBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              dua.label,
              style: TextStyle(
                fontSize: getFont(11),
                fontWeight: FontWeight.w600,
                color: dua.labelColor,
              ),
            ),
          ),
           SizedBox(height: getHeight(12)),
          // Arabic text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              dua.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style:  TextStyle(
                fontSize: getFont(22),
                height: getHeight(2.2),
                color: Color(0xFF1A1A1A),
                fontFamily: 'serif',
              ),
            ),
          ),
           SizedBox(height: getHeight(8)),
          // Urdu text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              dua.urdu,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style:  TextStyle(
                fontSize:getFont(15) ,
                height: 1.9,
                color: Color(0xFF444444),
              ),
            ),
          ),
           Divider(height: getHeight(20),
            color: Color(0xFFEEEEEE)),
          // Roman Urdu translation
          Text(
            dua.translation,
            style:  TextStyle(
              fontSize: getFont(13),
              height: getHeight(1.6),
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}
class BookmarkManager {
  // Singleton
  static final BookmarkManager instance = BookmarkManager._();
  BookmarkManager._();

  // Set of bookmarked arabic texts (unique identifier)
  final ValueNotifier<Set<String>> bookmarkedArabic =
  ValueNotifier<Set<String>>({});

  bool isBookmarked(String arabic) => bookmarkedArabic.value.contains(arabic);

  /// Toggles bookmark and returns whether it is now bookmarked
  bool toggle(String arabic) {
    final updated = Set<String>.from(bookmarkedArabic.value);
    bool isNowBookmarked;
    if (updated.contains(arabic)) {
      updated.remove(arabic);
      isNowBookmarked = false;
    } else {
      updated.add(arabic);
      isNowBookmarked = true;
    }
    bookmarkedArabic.value = updated;
    return isNowBookmarked;
  }
}
class DuasCard extends StatelessWidget {
  final Dua dua;
  const DuasCard({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      padding:  EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label + Bookmark row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:  EdgeInsets.symmetric(
                  horizontal: getWidth(10),
                  vertical: getHeight(4),
                ),
                decoration: BoxDecoration(
                  color: dua.labelBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  dua.label,
                  style: TextStyle(
                    fontSize: getFont(11),
                    fontWeight: FontWeight.w600,
                    color: dua.labelColor,
                  ),
                ),
              ),

              // ✅ Bookmark icon with toggle
              ValueListenableBuilder<Set<String>>(
                valueListenable: BookmarkManager.instance.bookmarkedArabic,
                builder: (context, bookmarks, _) {
                  final saved = bookmarks.contains(dua.arabic);
                  return GestureDetector(
                    onTap: () {
                      BookmarkManager.instance.toggle(dua.arabic);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            saved
                                ? 'Bookmark hata diya gaya'
                                : 'Bookmark ho gaya! ✅',
                          ),
                          duration: const Duration(milliseconds: 800),
                          backgroundColor: saved
                              ? Colors.grey
                              : const Color(0xff5BC0BE),
                        ),
                      );
                    },
                    child: Icon(
                      saved ? Icons.bookmark : Icons.bookmark_border_outlined,
                      color: saved
                          ? const Color(0xff5BC0BE)
                          : Colors.grey.shade400,
                      size: 22,
                    ),
                  );
                },
              ),
            ],
          ),

           SizedBox(height: getHeight(12)),

          // Arabic text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              dua.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style:  TextStyle(
                fontSize: getFont(22),
                height: 2.2,
                color: Color(0xFF1A1A1A),
                fontFamily: 'serif',
              ),
            ),
          ),
           SizedBox(height: getHeight(8)),

          // Urdu text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              dua.urdu,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style:  TextStyle(
                fontSize:getFont(15),
                height: 1.9,
                color: Color(0xFF444444),
              ),
            ),
          ),
           Divider(height: getHeight(20), color: Color(0xFFEEEEEE)),

          // Roman Urdu translation
          Text(
            dua.translation,
            style:  TextStyle(
              fontSize: getFont(13),
              height: 1.6,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}
class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  // Sab duas mein se bookmarked wali dhundho
  List<Dua> _getBookmarkedDuas(Set<String> bookmarkedArabic) {
    final List<Dua> result = [];
    for (final subject in subjects) {
      for (final dua in subject.duas) {
        if (bookmarkedArabic.contains(dua.arabic)) {
          result.add(dua);
        }
      }
    }
    return result;
  }

  // namesList mein se bookmarked wali dhundho
  List<DuaModel> _getBookmarkedDuaModels(Set<String> bookmarkedArabic) {
    return namesList.where((d) => bookmarkedArabic.contains(d.arabic)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:  Text(
          '🔖 Bookmarks',
          style: TextStyle(
            fontSize: getFont(18),
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: BookmarkManager.instance.bookmarkedArabic,
        builder: (context, bookmarkedArabic, _) {
          final subjectDuas = _getBookmarkedDuas(bookmarkedArabic);
          final modelDuas = _getBookmarkedDuaModels(bookmarkedArabic);

          // Dono lists empty hain
          if (subjectDuas.isEmpty && modelDuas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 72,
                    color: Colors.grey.shade300,
                  ),
                   SizedBox(height: getHeight(16)),
                   Text(
                    'No bookmarks found.',
                    style: TextStyle(
                      fontSize: getFont(16),
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                   SizedBox(height: getHeight(8)),
                   Text(
                    'Tap the bookmark icon on any Dua.',
                    style: TextStyle(fontSize: getFont(13), color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Subject-wise Dua Cards ─────────────────────────────────
              if (subjectDuas.isNotEmpty) ...[
                 Text(
                  'Subject Wise Duas',
                  style: TextStyle(
                    fontSize: getFont(14),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
                 SizedBox(height: getHeight(10)),
                ...subjectDuas.map(
                  (dua) => Padding(
                    padding:  EdgeInsets.only(bottom: getHeight(12)),
                    child: DuaCard(dua: dua),
                  ),
                ),
              ],

              // ── All Dua (namesList) Cards ──────────────────────────────
              if (modelDuas.isNotEmpty) ...[
                 SizedBox(height: getHeight(8)),
                 Text(
                  'All Duas',
                  style: TextStyle(
                    fontSize: getFont(14),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
                 SizedBox(height: getHeight(10)),
                ...modelDuas.asMap().entries.map(
                  (entry) => AllBookMarkDuaCard(
                    index: (entry.key + 1).toString(),
                    arabicName: entry.value.arabic,
                    englishName: entry.value.english,
                    urdu: entry.value.urdu,
                    reference: entry.value.reference,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class AllBookMarkDuaCard extends StatelessWidget {
  final String index;
  final String arabicName;
  final String englishName;
  final String urdu;
  final String reference;

  const AllBookMarkDuaCard({
    super.key,
    required this.index,
    required this.arabicName,
    required this.englishName,
    required this.urdu,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin:  EdgeInsets.symmetric(
        horizontal: getWidth(12), 
        vertical: getHeight(8)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding:  EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Index
            Text(
              index,
              style:  TextStyle(
                fontSize: getFont(14),
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

             SizedBox(height: getHeight(8)),

            // Arabic
            Text(
              arabicName,
              textAlign: TextAlign.right,
              style:  TextStyle(fontSize: getFont(20),
               fontWeight: FontWeight.bold),
            ),

             SizedBox(height: getHeight(20)),

            // English
            Text(
              englishName,
              style:  TextStyle(fontSize: getFont(16), color: Colors.black87),
            ),

             SizedBox(height: getHeight(8)),

            // Urdu
            Text(
              urdu,
              textDirection: TextDirection.rtl,
              style:  TextStyle(fontSize: getFont(16), color: Colors.black54),
            ),

             SizedBox(height: getHeight(10)),

            // Reference
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                reference,
                style:  TextStyle(
                  fontSize: getFont(12),
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

