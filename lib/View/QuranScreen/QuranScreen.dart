import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';

import '../../AllApiLink/AllApiLink.dart';
import '../../Model/SupaBase/AlQuranModel.dart';
import '../../Utils/Constants/AllColors.dart';
import '../../Utils/Constants/AllImages.dart';
import '../../Utils/Constants/SizeConfig.dart';
import '../../Utils/Constants/userFeedback.dart';
import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_notification/main.dart';


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
      padding: EdgeInsets.symmetric(vertical: getHeight(8)),
      child: InkWell(
        onTap: ontap,
        child: Row(
          children: [
            Container(
              width: getWidth(6),
              height: getHeight(60),
              decoration: BoxDecoration(
                color: const Color(0xff5BC0BE),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(width: getWidth(12)),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getWidth(16),
                  vertical: getHeight(14)),
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
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: getFont(12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: getWidth(16)),
                    Expanded(
                      child: Text(
                        subname,
                        style: AppColors().customTextStyle14(
                          color: Colors.black,
                          fontWeight: FontWeight.w600)
                      ),
                    ),
                    Spacer(),
                    Text(
                      name,
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

class SurahCard extends StatelessWidget {
  final int index;
  final String surahName;
  final String arabicName;
  final int ayahCount;
  final String revelationType;

  const SurahCard({
    super.key,
    required this.index,
    required this.surahName,
    required this.arabicName,
    required this.ayahCount,
    required this.revelationType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getHeight(8)),
      child: Row(
        children: [
          Container(
            width: getWidth(6),
            height: getHeight(60),
            decoration: BoxDecoration(
              color: const Color(0xff5BC0BE),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: getWidth(12)),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(16),
                vertical: getHeight(12)),
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
                          surahName,
                          style: TextStyle(
                            fontSize: getFont(16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: getHeight(4)),
                        Text(
                          "$ayahCount Ayahs • $revelationType",
                          style: TextStyle(
                            fontSize: getFont(12),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    arabicName,
                    style: TextStyle(
                      fontSize: getFont(20),
                      color: Color(0xff5BC0BE),
                      fontWeight: FontWeight.w600,
                    ),
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

class JuzListScreens extends StatefulWidget {
  const JuzListScreens({super.key});

  @override
  State<JuzListScreens> createState() => _JuzListScreensState();
}

class _JuzListScreensState extends State<JuzListScreens>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool showSurahTab = false;
  int selectedJuz = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.index = 0;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void onJuzTap(int juzNumber) {
    setState(() {
      selectedJuz = juzNumber;
      showSurahTab = true;
      _tabController!.index = 1;
    });
  }

  void onSurahTap(Surahmodelsss surah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahDetailssScreen(surah: surah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Al Quran",
            style: AppColors().customTextStyleBold16().copyWith(
              fontSize: getFont(16),
            )
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
          child: Column(
            children: [
              SizedBox(height: getHeight(10)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidth(12),
                      vertical: getHeight(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       Expanded(
  flex: 2,
  child: Stack(
    alignment: Alignment.center,
    children: [
      // Glow / Shadow
      ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 35,
          sigmaY: 35,
        ),
        child: SvgPicture.asset(
          "assets/icons/Quranpakiocn.svg",
          height: getHeight(150),
          colorFilter: ColorFilter.mode(
            const Color(0xFF65D6EC).withOpacity(0.65),
            BlendMode.srcIn,
          ),
        ),
      ),

      // Original Icon
      SvgPicture.asset(
        "assets/icons/Quranpakiocn.svg",
        height: getHeight(150),
        fit: BoxFit.contain,
      ),
    ],
  ),
),
                        SizedBox(width: getWidth(10)),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SvgPicture.asset(
                                  AllImages.bismillah,
                                  height: getHeight(35),
                                  width: getWidth(178),
                                ),
                              ),
                              SizedBox(height: getHeight(15)),
                              Text(
                                AllText.quranKareem,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppColors().customTextStyleBold16(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: getHeight(8)),
                              Text(
                                AllText.multipletranslation,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppColors().customTextStyle12(
                                  color: AppColors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              TabBar(
                dividerHeight: 0,
                labelColor: AppColors.primaryColor,
                indicatorColor: AppColors.primaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                onTap: (index) {
                  if (index == 1 && !showSurahTab) {
                    _tabController!.animateTo(0);
                  }
                },
                tabs: [
                  const Tab(text: "Para"),
                  if (showSurahTab)
                    const Tab(text: "Surah")
                  else
                    const Tab(text: ""),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: showSurahTab
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: juzList.length,
                      itemBuilder: (context, index) {
                        final juz = juzList[index];
                        final juzNumber = index + 1;
                        return ParahCard(
                          index: juzNumber,
                          name: juz.name,
                          subname: juz.subname,
                          ontap: () => onJuzTap(juzNumber),
                        );
                      },
                    ),
                    JuzDetailScreen(
                      key: ValueKey(selectedJuz),
                      juzNumber: selectedJuz,
                      onSurahTap: onSurahTap,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class JuzDetailScreen extends StatefulWidget {
  final int juzNumber;
  final Function(Surahmodelsss) onSurahTap;

  const JuzDetailScreen({
    super.key,
    required this.juzNumber,
    required this.onSurahTap,
  });

  @override
  State<JuzDetailScreen> createState() => _JuzDetailScreenState();
}

class _JuzDetailScreenState extends State<JuzDetailScreen> {
  QuranResponseModel? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadJuz();
  }

  Future<void> _loadJuz() async {
    if (!mounted) return;
    setState(() => _loading = true);

    final result = await QuranApiService.fetchJuzDetail(widget.juzNumber);

    if (!mounted) return;

    setState(() {
      _data = result;
      _loading = false;
    });

    if (result == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load Juz")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<AyahModel> ayahs =
        (_data?.data?.ayahs ?? []).cast<AyahModel>();

    final Map<int, Surahmodelsss> surahMap = {};
    for (final ayah in ayahs) {
      if (ayah.surah != null && !surahMap.containsKey(ayah.surah!.number)) {
        surahMap[ayah.surah!.number!] = ayah.surah!;
      }
    }

    return _loading
        ? Center(child: spinkit)
        : ListView(
            padding: EdgeInsets.all(10),
            children: surahMap.values.map((s) {
              return GestureDetector(
                onTap: () => widget.onSurahTap(s),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: getHeight(8)),
                  child: Row(
                    children: [
                      Container(
                        width: getWidth(6),
                        height: getHeight(60),
                        decoration: BoxDecoration(
                          color: const Color(0xff5BC0BE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(width: getWidth(12)),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: getWidth(16),
                            vertical: getHeight(14)),
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
                                    height: 40,
                                    width: 40),
                                  Text(
                                    '${s.number}',
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
                                      s.englishName ?? '',
                                      style: TextStyle(
                                        fontSize: getFont(16),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: getHeight(4)),
                                    Text(
                                      "${s.numberOfAyahs}Ayahs • ${s.revelationType}",
                                      style: TextStyle(
                                        fontSize: getFont(14),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
  }
}

// ═══════════════════════════════════════════════════════════════
// SURAH DETAIL SCREEN — Audio caching + pre-fetch fix
// ═══════════════════════════════════════════════════════════════
class SurahDetailssScreen extends StatefulWidget {
  final Surahmodelsss surah;

  const SurahDetailssScreen({super.key, required this.surah});

  @override
  State<SurahDetailssScreen> createState() => _SurahDetailssScreenState();
}

class _SurahDetailssScreenState extends State<SurahDetailssScreen> {
  QuranResponseModel? _data;
  bool _loading = true;
  AyahModel? _playingAyah;
  bool _isPlaying = false;
  int? _loadingAyahNumber;

  static const String _bismillahAudioUrl =
      "https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3";
  bool _awaitingBismillahThenAyah = false;
  AyahModel? _pendingAyahAfterBismillah;

  final ValueNotifier<Duration> _positionNotifier =
      ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _durationNotifier =
      ValueNotifier(Duration.zero);

  StreamSubscription? _durationSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _completeSub;
  StreamSubscription? _playerStateSub;

  static const List<String> _bismillahVariants = [
    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
    "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
    "بسم الله الرحمن الرحيم",
  ];

  String _removeDiacritics(String input) {
    final regex = RegExp(
      r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]',
    );
    return input.replaceAll(regex, '');
  }

  bool _isBismillahExcludedSurah(int? surahNumber) {
    return surahNumber == 1 || surahNumber == 9;
  }

  bool _hasBismillahPrefix(String text, int? surahNumber, int? numberInSurah) {
    if (numberInSurah != 1) return false;
    if (_isBismillahExcludedSurah(surahNumber)) return false;

    final normalizedText = _removeDiacritics(text)
        .replaceAll('ٱ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    const normalizedBismillah = 'بسم الله الرحمن الرحيم';
    return normalizedText.startsWith(normalizedBismillah);
  }

  String _stripBismillahPrefix(
      String text, int? surahNumber, int? numberInSurah) {
    if (!_hasBismillahPrefix(text, surahNumber, numberInSurah)) return text;

    final trimmed = text.trim();
    for (final variant in _bismillahVariants) {
      if (trimmed.startsWith(variant)) {
        return trimmed.substring(variant.length).trim();
      }
    }

    final normalizedText = _removeDiacritics(trimmed)
        .replaceAll('ٱ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    const bismillah = 'بسم الله الرحمن الرحيم';
    if (normalizedText.startsWith(bismillah)) {
      final words = trimmed.split(RegExp(r'\s+'));
      if (words.length > 4) return words.sublist(4).join(' ').trim();
    }

    return text;
  }

  @override
  void initState() {
    super.initState();
    _loadSurah();

    _durationSub = audioHandler.player.onDurationChanged.listen((d) {
      _durationNotifier.value = d;
    });

    _positionSub = audioHandler.player.onPositionChanged.listen((p) {
      _positionNotifier.value = p;
    });

    _completeSub = audioHandler.player.onPlayerComplete.listen((_) {
      if (_awaitingBismillahThenAyah && _pendingAyahAfterBismillah != null) {
        final ayah = _pendingAyahAfterBismillah!;
        _awaitingBismillahThenAyah = false;
        _pendingAyahAfterBismillah = null;
        if (ayah.audio != null) {
          _playActualAyahAudio(ayah.audio!, ayah);
        }
      } else {
        _playNextAyah();
      }
    });

    _playerStateSub =
        audioHandler.player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
        if (state == PlayerState.playing) {
          _loadingAyahNumber = null;
        }
      });
    });
  }

  void _playNextAyah() {
    final ayahs = _data?.data?.ayahs ?? [];
    if (_playingAyah == null || ayahs.isEmpty) return;
    final currentIndex =
        ayahs.indexWhere((a) => a.number == _playingAyah!.number);
    if (currentIndex != -1 && currentIndex < ayahs.length - 1) {
      final nextAyah = ayahs[currentIndex + 1];
      if (nextAyah.audio != null) _playAudio(nextAyah.audio!, nextAyah);
    } else {
      if (mounted) setState(() => _playingAyah = null);
    }
  }

  void _playPreviousAyah() {
    final ayahs = _data?.data?.ayahs ?? [];
    if (_playingAyah == null || ayahs.isEmpty) return;
    final currentIndex =
        ayahs.indexWhere((a) => a.number == _playingAyah!.number);
    if (currentIndex > 0) {
      final prevAyah = ayahs[currentIndex - 1];
      if (prevAyah.audio != null) _playAudio(prevAyah.audio!, prevAyah);
    }
  }

  Future<void> _loadSurah() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final result = await QuranApiService.fetchSurahAyahs(widget.surah.number!);
    if (!mounted) return;
    setState(() {
      _data = result;
      _loading = false;
    });
    if (result == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load Surah")),
      );
    }

    // ✅ Surah load hone ke baad pehli 3 ayahs pre-cache karo background mein
    _prefetchFirstAyahs();
  }

  // ✅ NEW: Pehli 3 ayahs ka audio silently download karo
  void _prefetchFirstAyahs() {
    final ayahs = _data?.data?.ayahs ?? [];
    final count = ayahs.length < 3 ? ayahs.length : 3;
    for (int i = 0; i < count; i++) {
      final url = ayahs[i].audio;
      if (url != null) {
        DefaultCacheManager().getSingleFile(url).catchError((_) {});
      }
    }
    // Bismillah audio bhi pre-cache karo
    DefaultCacheManager().getSingleFile(_bismillahAudioUrl).catchError((_) {});
  }

  //  Current ayah ke baad wali ayah background mein cache karo
  void _prefetchNextAyah(AyahModel currentAyah) {
    final ayahs = _data?.data?.ayahs ?? [];
    final currentIndex =
        ayahs.indexWhere((a) => a.number == currentAyah.number);
    if (currentIndex != -1 && currentIndex < ayahs.length - 1) {
      final nextUrl = ayahs[currentIndex + 1].audio;
      if (nextUrl != null) {
        DefaultCacheManager().getSingleFile(nextUrl).catchError((_) {});
      }
    }
  }

  Future<void> _playAudio(String url, AyahModel ayah) async {
    final needsBismillahIntro = _hasBismillahPrefix(
      ayah.text ?? "",
      widget.surah.number,
      ayah.numberInSurah,
    );

    if (needsBismillahIntro) {
      _awaitingBismillahThenAyah = true;
      _pendingAyahAfterBismillah = ayah;

      if (mounted) {
        setState(() {
          _loadingAyahNumber = ayah.number;
          _playingAyah = ayah;
        });
      }
      _positionNotifier.value = Duration.zero;
      _durationNotifier.value = Duration.zero;
      audioHandler.onTrackComplete = null;

      try {
        await audioHandler.playAyah(
          _bismillahAudioUrl,
          "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
          widget.surah.englishName ?? 'Quran',
        );
      } catch (e) {
        if (mounted) setState(() => _loadingAyahNumber = null);
        _awaitingBismillahThenAyah = false;
        _pendingAyahAfterBismillah = null;
      }
      return;
    }

    await _playActualAyahAudio(url, ayah);
  }

  Future<void> _playActualAyahAudio(String url, AyahModel ayah) async {
    if (mounted) {
      setState(() {
        _loadingAyahNumber = ayah.number;
        _playingAyah = ayah;
      });
    }

    _positionNotifier.value = Duration.zero;
    _durationNotifier.value = Duration.zero;

    try {
      await audioHandler.playAyah(
        url,
        "آیت ${ayah.numberInSurah}",
        widget.surah.englishName ?? 'Quran',
      );
    } catch (e) {
      if (mounted) setState(() => _loadingAyahNumber = null);
      return;
    }

    audioHandler.onSkipToNext = _playNextAyah;
    audioHandler.onSkipToPrevious = _playPreviousAyah;

    //  Next ayah background mein pre-fetch — tap karte waqt ready ho
    _prefetchNextAyah(ayah);
  }

  @override
  void dispose() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _completeSub?.cancel();
    _playerStateSub?.cancel();
    _positionNotifier.dispose();
    _durationNotifier.dispose();
    audioHandler.onTrackComplete = null;
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final ayahs = _data?.data?.ayahs ?? [];
    final surahNumber = widget.surah.number;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: getHeight(65),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.surah.englishName ?? '',
              style: AppColors().customTextStyleBold16()
            ),
            SizedBox(height: getHeight(3)),
            Text(
              widget.surah.englishNameTranslation ?? '',
              style: AppColors().customTextStyle14(
                color: const Color(0xff5BC0BE),
              ).copyWith(fontSize: getFont(12)),
            ),
          ],
          
        ),
         bottom: PreferredSize(
    preferredSize: const Size.fromHeight(0.12),
    child: Container(
      color: const Color(0xFF6B7678),
      height: 0.12,
    ),
  ),
      ),
      body: _loading
          ? Center(child: spinkit)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: ayahs.length,
                    itemBuilder: (context, index) {
                      final ayah = ayahs[index];
                      final isPlaying =
                          _playingAyah?.number == ayah.number && _isPlaying;
                      final isLoadingThis =
                          _loadingAyahNumber == ayah.number;

                      final rawText = ayah.text ?? "";
                      final showBismillahHeader = _hasBismillahPrefix(
                        rawText,
                        surahNumber,
                        ayah.numberInSurah,
                      );
                      final displayText = showBismillahHeader
                          ? _stripBismillahPrefix(
                              rawText, surahNumber, ayah.numberInSurah)
                          : rawText;

                      return Container(
                        key: ValueKey(ayah.number),
                        margin: EdgeInsets.only(bottom: getHeight(16)),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Juz: ${ayah.juz}  |  Page: ${ayah.page}",
                                  style: TextStyle(
                                    fontSize: getFont(12),
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: isLoadingThis
                                          ? null
                                          : () async {
                                              if (_playingAyah?.number ==
                                                  ayah.number) {
                                                if (_isPlaying) {
                                                  await audioHandler.player
                                                      .pause();
                                                } else {
                                                  await audioHandler.player
                                                      .resume();
                                                }
                                              } else if (ayah.audio != null) {
                                                _playAudio(
                                                    ayah.audio!, ayah);
                                              }
                                            },
                                      child: Container(
                                        width: getWidth(30),
                                        height: getHeight(30),
                                        decoration: BoxDecoration(
                                          color: isPlaying
                                              ? const Color(0xFFE6F1FB)
                                              : const Color(0xff5BC0BE),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: isLoadingThis
                                              ? SpinKitFadingCircle(
                                                  color: isPlaying
                                                      ? const Color(
                                                          0xff5BC0BE)
                                                      : Colors.white,
                                                  size: 20,
                                                )
                                              : Icon(
                                                  isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: getWidth(15)),
                                    Container(
                                      width: getWidth(30),
                                      height: getHeight(30),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff5BC0BE),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${ayah.numberInSurah}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            if (showBismillahHeader) ...[
                              SizedBox(height: getHeight(14)),
                              Center(
                                child: Text(
                                  _bismillahVariants.first,
                                  style: AppColors().customTextStyleAmiri22(
                                    color: const Color(0xff5BC0BE),
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            SizedBox(height: getHeight(16)),
                            Text(
                              displayText,
                              style: AppColors().customTextStyleAmiri24(
                                  color: Colors.black87,
                                  height: getHeight(2.5)),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                if (_playingAyah != null)
                  _MiniPlayerBar(
                    revelationType: widget.surah.revelationType ?? '',
                    englishName: widget.surah.englishName ?? '',
                    numberInSurah: _playingAyah?.numberInSurah,
                    isPlaying: _isPlaying,
                    isLoading:
                        _loadingAyahNumber == _playingAyah?.number,
                    positionNotifier: _positionNotifier,
                    durationNotifier: _durationNotifier,
                    formatDuration: _formatDuration,
                    onPlayPause: () async {
                      if (_isPlaying) {
                        await audioHandler.player.pause();
                      } else {
                        await audioHandler.player.resume();
                      }
                    },
                    onSeek: (value) async {
                      await audioHandler.player
                          .seek(Duration(seconds: value.toInt()));
                    },
                  ),
              ],
            ),
    );
  }
}

class _MiniPlayerBar extends StatelessWidget {
  final String revelationType;
  final String englishName;
  final int? numberInSurah;
  final bool isPlaying;
  final bool isLoading;
  final ValueNotifier<Duration> positionNotifier;
  final ValueNotifier<Duration> durationNotifier;
  final String Function(Duration) formatDuration;
  final VoidCallback onPlayPause;
  final ValueChanged<double> onSeek;

  const _MiniPlayerBar({
    required this.revelationType,
    required this.englishName,
    required this.numberInSurah,
    required this.isPlaying,
    required this.isLoading,
    required this.positionNotifier,
    required this.durationNotifier,
    required this.formatDuration,
    required this.onPlayPause,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      padding: EdgeInsets.fromLTRB(14, 8, 14, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.music_note, color: Colors.white60, size: 18),
              SizedBox(width: getWidth(8)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(revelationType,
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: getFont(11))),
                    Text(
                      '$englishName · آیت $numberInSurah',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: getFont(13),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: onPlayPause,
                    ),
            ],
          ),
          ValueListenableBuilder<Duration>(
            valueListenable: positionNotifier,
            builder: (context, position, _) {
              return ValueListenableBuilder<Duration>(
                valueListenable: durationNotifier,
                builder: (context, duration, __) {
                  final maxSeconds = duration.inSeconds.toDouble() > 0
                      ? duration.inSeconds.toDouble()
                      : 1.0;
                  final valueSeconds =
                      position.inSeconds.toDouble().clamp(0, maxSeconds);

                  return Row(
                    children: [
                      Text(formatDuration(position),
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: getFont(10))),
                      SizedBox(width: getWidth(6)),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2.5,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 12),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.white30,
                            thumbColor: Colors.white,
                            overlayColor: Colors.white24,
                          ),
                          child: Slider(
                            min: 0,
                            max: maxSeconds,
                            value: valueSeconds.toDouble(),
                            onChanged: onSeek,
                          ),
                        ),
                      ),
                      SizedBox(width: getWidth(6)),
                      Text(formatDuration(duration),
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: getFont(10))),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// QURAN AUDIO HANDLER — Cache-first playback (delay fix)
// ═══════════════════════════════════════════════════════════════
class QuranAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;
  VoidCallback? onTrackComplete;
  VoidCallback? onSkipToNext;
  VoidCallback? onSkipToPrevious;

  QuranAudioHandler() {
    _player.onPlayerStateChanged.listen((state) {
      playbackState.add(playbackState.value.copyWith(
        playing: state == PlayerState.playing,
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.pause,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {MediaAction.seek},
        processingState: state == PlayerState.completed
            ? AudioProcessingState.completed
            : AudioProcessingState.ready,
      ));

      if (state == PlayerState.completed) {
        onTrackComplete?.call();
      }
    });

    _player.onPositionChanged.listen((pos) {
      playbackState.add(playbackState.value.copyWith(updatePosition: pos));
    });

    _player.onDurationChanged.listen((dur) {
      final current = mediaItem.value;
      if (current != null) {
        mediaItem.add(current.copyWith(duration: dur));
      }
    });
  }


  Future<void> playAyah(String url, String title, String surahName) async {
    await _player.stop();

    mediaItem.add(MediaItem(
      id: url,
      album: surahName,
      title: title,
      artist: "Quran Recitation",
      artUri: Uri.parse('asset:///assets/images/quran_cover.png'),
    ));

    try {
      // Cache mein check karo — agar file hai to seedha local se play
      final file = await DefaultCacheManager().getSingleFile(url);
      await _player.play(DeviceFileSource(file.path)); 
    } catch (e) {
      // Cache fail ho to direct URL fallback
      debugPrint('Cache miss, playing from URL: $e');
      await _player.play(UrlSource(url));
    }
  }

  @override
  Future<void> play() => _player.resume();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
    ));
  }

  @override
  Future<void> skipToNext() async => onSkipToNext?.call();

  @override
  Future<void> skipToPrevious() async => onSkipToPrevious?.call();

  @override
  Future<void> seek(Duration position) => _player.seek(position);
}