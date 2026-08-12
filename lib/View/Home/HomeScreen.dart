import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification/View/Listscreen/ListScreen.dart';
import '../../Model/PrayerCacheModel.dart';
import '../../Utils/Constants/AllColors.dart';
import '../../Utils/Constants/AllImages.dart';
import '../../Utils/Constants/AllText.dart';
import '../../Utils/Constants/ShimmerUI.dart';
import '../../Utils/Constants/SizeConfig.dart';
import '../AllahName/AllahNameScreen.dart';
import '../Hadith/HadithScreen.dart';
import '../Islamic_Calander/Islamic_Calander.dart';
import '../MuhammadName/MuhammadNameScreen.dart';
import '../Prayer/PrayersTimeScreen.dart';
import '../QuranScreen/QuranScreen.dart';
import '../Ramzan/RamdanScreen.dart';
import '../Video/VideoScreen.dart';
import '../ZakatCalender/ZakatScreen.dart';
import 'dart:async';
import 'subScreen/AllDuaScreen.dart';
import 'subScreen/TasbihScreen.dart';

abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

class TickTimer extends HomeEvent {}
// --- State ---

class HomeState {
  final bool isLoading;
  final String locationName;
  final List<Map<String, String>> dynamicPrayerTimes;
  final Map<String, String> cachedTimings;
  final String gregorianDate;
  final String hijriDate;

  HomeState({
    this.isLoading = true,

    this.locationName = 'Loading...',

    this.dynamicPrayerTimes = const [],

    this.cachedTimings = const {},

    this.gregorianDate = '',

    this.hijriDate = '',
  });

  HomeState copyWith({
    bool? isLoading,

    String? locationName,

    List<Map<String, String>>? dynamicPrayerTimes,

    Map<String, String>? cachedTimings,

    String? gregorianDate,

    String? hijriDate,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,

      locationName: locationName ?? this.locationName,

      dynamicPrayerTimes: dynamicPrayerTimes ?? this.dynamicPrayerTimes,

      cachedTimings: cachedTimings ?? this.cachedTimings,

      gregorianDate: gregorianDate ?? this.gregorianDate,

      hijriDate: hijriDate ?? this.hijriDate,
    );
  }
}

// --- Bloc ---
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SalatTimeService _service = SalatTimeService();

  final HiveService _hive = HiveService();

  Timer? _timer;

  HomeBloc() : super(HomeState()) {
    on<LoadHomeData>(_onLoadData);

    on<RefreshHomeData>(_onRefreshData);

    on<TickTimer>((event, emit) => emit(state.copyWith()));

    _timer = Timer.periodic(
      const Duration(minutes: 1), (timer) {
      add(TickTimer());
    });
  }

  Future<void> _onLoadData(LoadHomeData event, Emitter<HomeState> emit) async {
    final cache = _hive.loadTodayCache();

    if (cache != null) {
      _emitCache(cache, emit);

      add(RefreshHomeData());
    } else {
      await _fetchData(emit);
    }
  }

  Future<void> _onRefreshData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<HomeState> emit) async {
    try {
      final result = await _service.fetchPrayerTimes();

      if (result.salatTime != null) {
        final timings = result.salatTime!.data!.timings!;

        final timingMap = {
          'Fajr': _cleanTime(timings.fajr),

          'Dhuhr': _cleanTime(timings.dhuhr),

          'Asr': _cleanTime(timings.asr),

          'Maghrib': _cleanTime(timings.maghrib),

          'Isha': _cleanTime(timings.isha),
        };

        final h = result.salatTime!.data!.date!.hijri!;

        emit(
          state.copyWith(
            isLoading: false,

            locationName: result.locationName,

            cachedTimings: timingMap,

            dynamicPrayerTimes: _buildPrayerList(timingMap),

            gregorianDate:
                result.salatTime!.data!.date!.gregorian?.readable ?? '',

            hijriDate: '${h.day} ${h.month?.en} ${h.year} AH',
          ),
        );
      }
    } catch (_) {}
  }

  void _emitCache(PrayerCache cache, Emitter<HomeState> emit) {
    final timingMap = {
      'Fajr': cache.fajr,
      'Dhuhr': cache.dhuhr,
      'Asr': cache.asr,
      'Maghrib': cache.maghrib,
      'Isha': cache.isha,
    };

    emit(
      state.copyWith(
        isLoading: false,

        locationName: cache.locationName,

        cachedTimings: timingMap,

        dynamicPrayerTimes: _buildPrayerList(timingMap),

        gregorianDate: cache.gregorianReadable,

        hijriDate:
            '${cache.hijriDay} ${cache.hijriMonth} ${cache.hijriYear} AH',
      ),
    );
  }

  String _cleanTime(String? raw) => raw?.split(' ').first ?? '--:--';

  List<Map<String, String>> _buildPrayerList(Map<String, String> timings) {
    return [
      {
        'Prayer': 'Fajr',
        'Adhun': _formatTime(timings['Fajr']),
        'Iqama': _calculateIqama(timings['Fajr'], 20),
      },

      {
        'Prayer': 'Dhuhr',
        'Adhun': _formatTime(timings['Dhuhr']),
        'Iqama': _calculateIqama(timings['Dhuhr'], 15),
      },

      {
        'Prayer': 'Asr',
        'Adhun': _formatTime(timings['Asr']),
        'Iqama': _calculateIqama(timings['Asr'], 15),
      },

      {
        'Prayer': 'Maghrib',
        'Adhun': _formatTime(timings['Maghrib']),
        'Iqama': _calculateIqama(timings['Maghrib'], 5),
      },

      {
        'Prayer': 'Isha',
        'Adhun': _formatTime(timings['Isha']),
        'Iqama': _calculateIqama(timings['Isha'], 15),
      },
    ];
  }

  String _formatTime(String? raw) {
    if (raw == null || raw == '--:--') return '--:--';

    try {
      final parts = raw.split(':');

      int hour = int.parse(parts[0]);

      final period = hour >= 12 ? 'PM' : 'AM';

      if (hour > 12) hour -= 12;

      if (hour == 0) hour = 12;

      return '${hour.toString().padLeft(2, '0')}:${parts[1].padLeft(2, '0')} $period';
    } catch (_) {
      return raw;
    }
  }

  String _calculateIqama(String? rawAdhan, int minutesToAdd) {
    if (rawAdhan == null || rawAdhan == '--:--') return '--:--';

    try {
      final parts = rawAdhan.split(':');

      var time = DateTime(
        2000,
        1,
        1,
        int.parse(parts[0]),
        int.parse(parts[1]),
      ).add(Duration(minutes: minutesToAdd));

      int hour = time.hour;

      final period = hour >= 12 ? 'PM' : 'AM';

      if (hour > 12) hour -= 12;

      if (hour == 0) hour = 12;

      return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return '--:--';
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();

    return super.close();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),

      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          
          if (state.isLoading && state.cachedTimings.isEmpty) {
            return _buildShimmerEffect(width);
          }

          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IslamicCalendar(),
                          ),
                        );
                      },
                
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                
                           SizedBox(width: getWidth(4)),
                
                          Text(
                            "Today / ${_getDayName()}",
                
                            style: AppColors().customTextStyleBold16(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    SizedBox(height: getHeight(5)),
                
                    Text(
                      '${state.gregorianDate} / ${state.hijriDate}',
                
                      style: AppColors().customTextStyleCairo14(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                IconButton(
                  onPressed: () {
                   Navigator.push(
                   context,
                   MaterialPageRoute(
                   builder: (_) => const ListScreen(),
                   ),
                  );
                  },

                  icon: Icon(
                    Icons.menu, 
                    color: AppColors.primaryColor,
                    ),
                ),
              ],
            ),

            body: Container(
               decoration:  BoxDecoration(
               image: DecorationImage(
               image: AssetImage(AllImages.splashback),
               fit: BoxFit.cover,
    ),
  ),
              child: RefreshIndicator(
                onRefresh: () async =>
                    context.read<HomeBloc>().add(RefreshHomeData()),
                child: Padding(
                  padding:  EdgeInsets.symmetric(
                    horizontal: getWidth(16),
                    ),
              
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getHeight(10)),
                      _buildTopBanner(width, state),
                      SizedBox(height: getHeight(20)),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 1,
                              childAspectRatio: 0.78,
                            ),
                  
                        itemCount: _getGridItems(context).length,
                  
                        itemBuilder: (context, index) {
                          final gridItems = _getGridItems(context);
                  
                          return GridViewicon(
                            icon: SvgPicture.asset(
                              gridItems[index]["icon"],
                              color: Colors.white,
                              height: getHeight(32),
                            ),
                  
                            title: gridItems[index]["title"],
                  
                            onclick: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => gridItems[index]["screen"],
                              ),
                            ),
                          );
                        },
                      ),
                  
                      SizedBox(height: getHeight(12)),
                  
                      _buildDuaSection(context),
                  
                      SizedBox(height: getHeight(12)),
                  
                      Text(
                        "Prayer Time",
                        style: AppColors().customTextStyleBold16(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: getHeight(12)),
                      _buildPrayerTable(width, state, context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerEffect(double width) {
    return Scaffold(
      appBar: AppBar(
        title: AppShimmer(
        width: width * 0.5,
         height: getHeight(20),
         )),

      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: getWidth(16),),

        child: Column(
          children: [
            SizedBox(height: getHeight(12)),

            AppShimmer(width: width, height: getHeight(148)), 

            SizedBox(height: getHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: List.generate(
                5,
                (index) => AppShimmer(
                  width: getWidth(65), 
                  height: getHeight(80),
                  ),
              ),
            ),
            SizedBox(height: getHeight(12)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: List.generate(
                5,
                (index) => AppShimmer(
                  width: getWidth(65),
                   height: getHeight(80),
                   ),
              ),
            ),

            SizedBox(height: getHeight(20)),

            AppShimmer(
              width: width,
               height: getHeight(100),
               ), // Dua Section

            //
            // SizedBox(height: getHeight(12)),
            //
            // AppShimmer(width: 120, height: 20), 
            SizedBox(height: getHeight(10)),

            AppShimmer(
              width: width, 
              height: getHeight(220)
              ),
          ],
        ),
      ),
    );
  }
  // --- UI Widgets copied directly from your code ---

  Widget _buildTopBanner(
    double width, 
    HomeState state
    ) {
    return Container(
      // height: getHeight(148),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primaryColor,
        image: DecorationImage(
          image: AssetImage(AllImages.containerBackground),

          fit: BoxFit.cover,
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Padding(
            padding:  EdgeInsets.only(
              left: getWidth(10),
              ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _bannerText(
                  AllText.now,
                  _getCurrentPrayerName(state.cachedTimings),
                ),

                _bannerText(
                  AllText.upcoming,
                  _getUpcomingPrayerName(state.cachedTimings),
                ),

                _bannerText("Location", state.locationName),
              ],
            ),
          ),

         SvgPicture.asset(
  AllImages.quranpak,
  width: getWidth(40),
  height: getHeight(120),
  fit: BoxFit.contain,
)
        ],
      ),
    );
  }

  Widget _buildPrayerTable(
  double width,
  HomeState state,
  BuildContext context,
) {
  return Expanded(
    child: Container(
      width: width,
      height: getHeight(220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(AllImages.prayertimebackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          // ✅ Fixed Header Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 45,
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.28,
                    child: const Text(
                      'Prayer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.28,
                    child: const Text(
                      'Adhan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.28,
                    child: const Text(
                      'Iqama',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Divider (optional)
          Divider(color: Colors.white.withOpacity(0.3), height: 1),

          // ✅ Scrollable Rows
          Expanded(
            child: ListView.builder(
              itemCount: state.dynamicPrayerTimes.length,
              itemBuilder: (context, index) {
                final time = state.dynamicPrayerTimes[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(15),
                     vertical: getHeight(6)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.28,
                        child: Text(
                          time['Prayer']!,
                          style: AppColors().customTextStyle14(
                            color: Colors.white,
                            ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.28,
                        child: Text(
                          time['Adhun']!,
                          style: AppColors().customTextStyle14(
                            color: Colors.white,
                            ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.28,
                        child: Text(
                          time['Iqama']!,
                          style: AppColors().customTextStyle14(
                            color: Colors.white,
                            ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
  // Helper Methods
  String _getDayName() => [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ][DateTime.now().weekday - 1];
  Widget _bannerText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppColors().customTextStyleRegular10(
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: getHeight(2)),
        Text(
          value,
          style: AppColors().customTextStyle12(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: getHeight(4)),
      ],
    );
  }

  Widget _buildDuaSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Daily Dua", style: AppColors().customTextStyleBold16()),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => AllDuaBloc(),

                      child: const AllDuaScreen(),
                    ),
                  ),
                );
              },
              child: Text(
                "See all",
                style: AppColors().customTextStyleBold16(
                  color:AppColors.primaryColor,
                  )
                
              ),
            ),
          ],
        ),
         SizedBox(height: getHeight(10)),

        AllDuaCard(showLeftLine: false),
      ],
    );
  }

  // Prayer Names Logic
  String _getCurrentPrayerName(Map<String, String> timings) {
    if (timings.isEmpty) return "--";

    final now = DateTime.now();

    try {
      final fajr = _parseToDateTime(timings['Fajr']!);

      final dhuhr = _parseToDateTime(timings['Dhuhr']!);

      final asr = _parseToDateTime(timings['Asr']!);

      final maghrib = _parseToDateTime(timings['Maghrib']!);

      final isha = _parseToDateTime(timings['Isha']!);

      if (now.isAfter(fajr) && now.isBefore(dhuhr)) return "Fajr";

      if (now.isAfter(dhuhr) && now.isBefore(asr)) return "Dhuhr";

      if (now.isAfter(asr) && now.isBefore(maghrib)) return "Asr";

      if (now.isAfter(maghrib) && now.isBefore(isha)) return "Maghrib";

      return "Isha";
    } catch (_) {
      return "--";
    }
  }

  String _getUpcomingPrayerName(Map<String, String> timings) {
    if (timings.isEmpty) return "--";

    final now = DateTime.now();

    try {
      final fajr = _parseToDateTime(timings['Fajr']!);

      final dhuhr = _parseToDateTime(timings['Dhuhr']!);

      final asr = _parseToDateTime(timings['Asr']!);

      final maghrib = _parseToDateTime(timings['Maghrib']!);

      final isha = _parseToDateTime(timings['Isha']!);

      if (now.isBefore(fajr)) return "Fajr";

      if (now.isBefore(dhuhr)) return "Dhuhr";

      if (now.isBefore(asr)) return "Asr";

      if (now.isBefore(maghrib)) return "Maghrib";

      if (now.isBefore(isha)) return "Isha";

      return "Fajr (Tomorrow)";
    } catch (_) {
      return "--";
    }
  }

  DateTime _parseToDateTime(String timeStr) {
    final parts = timeStr.split(':');

    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  List<Map<String, dynamic>> _getGridItems(BuildContext context) {
    return [
      {
        "icon": AllImages.allahicon,
        "title": "Allah",
        "screen": AllahNamesScreen(),
      },

      {
        "icon": AllImages.muhammadicon,
        "title": "Muhammad",
        "screen": MuhammadNameScreen(),
      },

      {"icon": AllImages.videoicon, "title": "Video", "screen": VideoScreen()},

      {
        "icon": AllImages.tasbih,
        "title": "Tasbih",
        "screen": const TasbihScreen(),
      },

      {
        "icon": AllImages.duaicon,
        "title": "Dua",
        "screen": BlocProvider(
          create: (context) => AllDuaBloc(),
          child: const AllDuaScreen(),
        ),
      },

      {"icon": AllImages.zakaticon, "title": "Zakat", "screen": ZakatScreen()},

      {
        "icon": AllImages.whiteCalander,
        "title": "Calendar",
        "screen": const IslamicCalendar(),
      },

      {"icon": AllImages.hadith, "title": "Hadith", "screen": HadithScreen()},

      {"icon": AllImages.quranic, "title": "Quran", "screen": JuzListScreens()},

      {
        "icon": AllImages.ramdhan,
        "title": "Ramadan",
        "screen": RamadanScreen(),
      },
    ];
  }
}

class GridViewicon extends StatelessWidget {
  final VoidCallback onclick;
  final String title;
  final SvgPicture icon;

  const GridViewicon({
    super.key,
    required this.icon,
    required this.title,
    required this.onclick,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: onclick,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: getHeight(65),
            width: getWidth(65),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: icon),
          ),
          SizedBox(height: getHeight(4)),
          Text(
            title,
            style: AppColors().customTextStyleRegular10(
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerTime extends StatelessWidget {
  final String heading;
  final String time;
  final String lasttime;
  PrayerTime({
    super.key,
    required this.heading,
    required this.time,
    required this.lasttime,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.only(
        top: getHeight(10),
         left: getWidth(15),
          right: getWidth(15)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            heading,
            style: AppColors().customTextStyle14(
              color: AppColors.white,
              fontWeight: FontWeight.w400,
            ),
          ),

          Column(
            children: [
              Text(
                time,
                style: AppColors().customTextStyle14(
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          Text(
            lasttime,
            style: AppColors().customTextStyle14(
              color: AppColors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Events ---
// abstract class HomeEvent {}
// class LoadHomeData extends HomeEvent {}
// class RefreshHomeData extends HomeEvent {}
// class TickTimer extends HomeEvent {}
//
// // --- State ---
// class HomeState {
//   final bool isLoading;
//   final String locationName;
//   final List<Map<String, String>> dynamicPrayerTimes;
//   final Map<String, String> cachedTimings;
//   final String gregorianDate;
//   final String hijriDate;
//
//   HomeState({
//     this.isLoading = true,
//     this.locationName = 'Loading...',
//     this.dynamicPrayerTimes = const [],
//     this.cachedTimings = const {},
//     this.gregorianDate = '',
//     this.hijriDate = '',
//   });
//
//   HomeState copyWith({
//     bool? isLoading,
//     String? locationName,
//     List<Map<String, String>>? dynamicPrayerTimes,
//     Map<String, String>? cachedTimings,
//     String? gregorianDate,
//     String? hijriDate,
//   }) {
//     return HomeState(
//       isLoading: isLoading ?? this.isLoading,
//       locationName: locationName ?? this.locationName,
//       dynamicPrayerTimes: dynamicPrayerTimes ?? this.dynamicPrayerTimes,
//       cachedTimings: cachedTimings ?? this.cachedTimings,
//       gregorianDate: gregorianDate ?? this.gregorianDate,
//       hijriDate: hijriDate ?? this.hijriDate,
//     );
//   }
// }
//
// // --- Bloc ---
// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final SalatTimeService _service = SalatTimeService();
//   final HiveService _hive = HiveService();
//   Timer? _timer;
//
//   HomeBloc() : super(HomeState()) {
//     on<LoadHomeData>(_onLoadData);
//     on<RefreshHomeData>(_onRefreshData);
//     on<TickTimer>((event, emit) => emit(state.copyWith()));
//
//     _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
//       add(TickTimer());
//     });
//   }
//
//   Future<void> _onLoadData(LoadHomeData event, Emitter<HomeState> emit) async {
//     final cache = _hive.loadTodayCache();
//     if (cache != null) {
//       _emitCache(cache, emit);
//       add(RefreshHomeData());
//     } else {
//       await _fetchData(emit);
//     }
//   }
//
//   Future<void> _onRefreshData(RefreshHomeData event, Emitter<HomeState> emit) async {
//     await _fetchData(emit);
//   }
//
//   Future<void> _fetchData(Emitter<HomeState> emit) async {
//     try {
//       final result = await _service.fetchPrayerTimes();
//       if (result.salatTime != null) {
//         final timings = result.salatTime!.data!.timings!;
//         final timingMap = {
//           'Fajr': _cleanTime(timings.fajr),
//           'Dhuhr': _cleanTime(timings.dhuhr),
//           'Asr': _cleanTime(timings.asr),
//           'Maghrib': _cleanTime(timings.maghrib),
//           'Isha': _cleanTime(timings.isha),
//         };
//         final h = result.salatTime!.data!.date!.hijri!;
//         emit(state.copyWith(
//           isLoading: false,
//           locationName: result.locationName,
//           cachedTimings: timingMap,
//           dynamicPrayerTimes: _buildPrayerList(timingMap),
//           gregorianDate: result.salatTime!.data!.date!.gregorian?.readable ?? '',
//           hijriDate: '${h.day} ${h.month?.en} ${h.year} AH',
//         ));
//       }
//     } catch (_) {}
//   }
//
//   void _emitCache(PrayerCache cache, Emitter<HomeState> emit) {
//     final timingMap = {'Fajr': cache.fajr, 'Dhuhr': cache.dhuhr, 'Asr': cache.asr, 'Maghrib': cache.maghrib, 'Isha': cache.isha};
//     emit(state.copyWith(
//       isLoading: false,
//       locationName: cache.locationName,
//       cachedTimings: timingMap,
//       dynamicPrayerTimes: _buildPrayerList(timingMap),
//       gregorianDate: cache.gregorianReadable,
//       hijriDate: '${cache.hijriDay} ${cache.hijriMonth} ${cache.hijriYear} AH',
//     ));
//   }
//
//   String _cleanTime(String? raw) => raw?.split(' ').first ?? '--:--';
//
//   List<Map<String, String>> _buildPrayerList(Map<String, String> timings) {
//     return [
//       {'Prayer': 'Fajr', 'Adhun': _formatTime(timings['Fajr']), 'Iqama': _calculateIqama(timings['Fajr'], 20)},
//       {'Prayer': 'Dhuhr', 'Adhun': _formatTime(timings['Dhuhr']), 'Iqama': _calculateIqama(timings['Dhuhr'], 15)},
//       {'Prayer': 'Asr', 'Adhun': _formatTime(timings['Asr']), 'Iqama': _calculateIqama(timings['Asr'], 15)},
//       {'Prayer': 'Maghrib', 'Adhun': _formatTime(timings['Maghrib']), 'Iqama': _calculateIqama(timings['Maghrib'], 5)},
//       {'Prayer': 'Isha', 'Adhun': _formatTime(timings['Isha']), 'Iqama': _calculateIqama(timings['Isha'], 15)},
//     ];
//   }
//
//   String _formatTime(String? raw) {
//     if (raw == null || raw == '--:--') return '--:--';
//     try {
//       final parts = raw.split(':');
//       int hour = int.parse(parts[0]);
//       final period = hour >= 12 ? 'PM' : 'AM';
//       if (hour > 12) hour -= 12;
//       if (hour == 0) hour = 12;
//       return '${hour.toString().padLeft(2, '0')}:${parts[1].padLeft(2, '0')} $period';
//     } catch (_) { return raw; }
//   }
//
//   String _calculateIqama(String? rawAdhan, int minutesToAdd) {
//     if (rawAdhan == null || rawAdhan == '--:--') return '--:--';
//     try {
//       final parts = rawAdhan.split(':');
//       var time = DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1])).add(Duration(minutes: minutesToAdd));
//       int hour = time.hour;
//       final period = hour >= 12 ? 'PM' : 'AM';
//       if (hour > 12) hour -= 12;
//       if (hour == 0) hour = 12;
//       return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
//     } catch (_) { return '--:--'; }
//   }
//
//   @override
//   Future<void> close() {
//     _timer?.cancel();
//     return super.close();
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     SizeConfig().init(context);
//
//     return BlocProvider(
//       create: (context) => HomeBloc()..add(LoadHomeData()),
//       child: BlocBuilder<HomeBloc, HomeState>(
//         builder: (context, state) {
//           // STEP 1: Agar first time load ho raha hai aur koi cache data nahi hai, to shimmer dikhao
//           if (state.isLoading && state.cachedTimings.isEmpty) {
//             return _buildShimmerEffect(width);
//           }
//           // STEP 2: Data milne par ya refresh hone par actual UI dikhao
//           return Scaffold(
//             appBar: AppBar(
//               centerTitle: false,
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => IslamicCalendar()));
//                     },
//                     child: Row(
//                       children: [
//                         Icon(Icons.calendar_month, color: AppColors.primaryColor, size: 18),
//                         const SizedBox(width: 4),
//                         Text("Today / ${_getDayName()}",
//                             style: AppColors().customTextStyleBold16(color: AppColors.primaryColor)),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: getHeight(5)),
//                   Text('${state.gregorianDate} / ${state.hijriDate}',
//                       style: AppColors().customTextStyleCairo14(color: Colors.grey)),
//                 ],
//               ),
//               actions: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.menu, color: AppColors.primaryColor),
//                 ),
//               ],
//             ),
//             body: RefreshIndicator(
//               onRefresh: () async => context.read<HomeBloc>().add(RefreshHomeData()),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: getHeight(12)),
//                     _buildTopBanner(width, state),
//                     SizedBox(height: getHeight(20)),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 5,
//                         crossAxisSpacing: 4,
//                         mainAxisSpacing: 1,
//                         childAspectRatio: 0.78,
//                       ),
//                       itemCount: _getGridItems(context).length,
//                       itemBuilder: (context, index) {
//                         final gridItems = _getGridItems(context);
//                         return GridViewicon(
//                           icon: SvgPicture.asset(gridItems[index]["icon"], color: Colors.white, height: 32),
//                           title: gridItems[index]["title"],
//                           onclick: () => Navigator.push(context, MaterialPageRoute(builder: (context) => gridItems[index]["screen"])),
//                         );
//                       },
//                     ),
//                     SizedBox(height: getHeight(12)),
//                     _buildDuaSection(context),
//                     SizedBox(height: getHeight(12)),
//                     Text("Prayer Time", style: AppColors().customTextStyleBold16(color: Colors.black)),
//                     SizedBox(height: getHeight(12)),
//                     _buildPrayerTable(width, state, context),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//
//     Widget _buildShimmerEffect(double width) {
//       return Scaffold(
//         appBar: AppBar(title: AppShimmer(width: width * 0.5, height: 20)),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             children: [
//               SizedBox(height: getHeight(12)),
//               AppShimmer(width: width, height: getHeight(148)), // Top Banner
//               SizedBox(height: getHeight(20)),
//               // Grid Shimmer (Simulating 5 items)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(5, (index) => AppShimmer(width: 65, height: 80)),
//               ),
//               SizedBox(height: getHeight(12)),
//               AppShimmer(width: width, height: 60), // Dua Section
//               SizedBox(height: getHeight(12)),
//               AppShimmer(width: 120, height: 20), // "Prayer Time" Text
//               SizedBox(height: getHeight(12)),
//               AppShimmer(width: width, height: getHeight(220)), // Table
//             ],
//           ),
//         ),
//       );
//     }
//
//
//
//
//
//
//
//
//   // --- UI Widgets copied directly from your code ---
//
//   Widget _buildTopBanner(double width, HomeState state) {
//     return Container(
//       height: getHeight(148),
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: AppColors.primaryColor,
//         image: DecorationImage(
//           image: AssetImage(AllImages.containerBackground),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _bannerText(AllText.now, _getCurrentPrayerName(state.cachedTimings)),
//                 _bannerText(AllText.upcoming, _getUpcomingPrayerName(state.cachedTimings)),
//                 _bannerText("Location", state.locationName),
//               ],
//             ),
//           ),
//           SvgPicture.asset(AllImages.quranpak, height: getHeight(150)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPrayerTable(double width, HomeState state, BuildContext context) {
//     return Expanded(
//       child: Container(
//         width: width,
//         height: getHeight(220),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: DecorationImage(
//             image: AssetImage(AllImages.prayertimebackground),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Theme(
//             data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//             child: DataTable(
//               columnSpacing: width * 0.12,
//               horizontalMargin: 15,
//               headingRowHeight: 45,
//               dividerThickness: 0.01,
//               columns: const [
//                 DataColumn(label: Text('Prayer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Adhan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Iqama', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//               ],
//               rows: state.dynamicPrayerTimes.map((time) => DataRow(
//                 cells: [
//                   DataCell(Text(time['Prayer']!, style: const TextStyle(color: Colors.white))),
//                   DataCell(Text(time['Adhun']!, style: const TextStyle(color: Colors.white))),
//                   DataCell(Text(time['Iqama']!, style: const TextStyle(color: Colors.white))),
//                 ],
//               )).toList(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper Methods
//   String _getDayName() => ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][DateTime.now().weekday - 1];
//
//   Widget _bannerText(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: AppColors().customTextStyleRegular10(color: AppColors.white, fontWeight: FontWeight.w400)),
//         SizedBox(height: getHeight(2)),
//         Text(value, style: AppColors().customTextStyle12(color: AppColors.white, fontWeight: FontWeight.w500)),
//         SizedBox(height: getHeight(4)),
//       ],
//     );
//   }
//
//   Widget _buildDuaSection(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text("Daily Dua", style: AppColors().customTextStyleBold16()),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) =>
//                         BlocProvider(create: (context) => AllDuaBloc(),
//                             child: const AllDuaScreen())));
//               },
//               child: Text("See All", style: TextStyle(color: AppColors.primaryColor, fontSize: 12)),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         AllDuaCard(showLeftLine: false),
//       ],
//     );
//   }
//
//   // Prayer Names Logic
//   String _getCurrentPrayerName(Map<String, String> timings) {
//     if (timings.isEmpty) return "--";
//     final now = DateTime.now();
//     try {
//       final fajr = _parseToDateTime(timings['Fajr']!);
//       final dhuhr = _parseToDateTime(timings['Dhuhr']!);
//       final asr = _parseToDateTime(timings['Asr']!);
//       final maghrib = _parseToDateTime(timings['Maghrib']!);
//       final isha = _parseToDateTime(timings['Isha']!);
//       if (now.isAfter(fajr) && now.isBefore(dhuhr)) return "Fajr";
//       if (now.isAfter(dhuhr) && now.isBefore(asr)) return "Dhuhr";
//       if (now.isAfter(asr) && now.isBefore(maghrib)) return "Asr";
//       if (now.isAfter(maghrib) && now.isBefore(isha)) return "Maghrib";
//       return "Isha";
//     } catch (_) { return "--"; }
//   }
//
//   String _getUpcomingPrayerName(Map<String, String> timings) {
//     if (timings.isEmpty) return "--";
//     final now = DateTime.now();
//     try {
//       final fajr = _parseToDateTime(timings['Fajr']!);
//       final dhuhr = _parseToDateTime(timings['Dhuhr']!);
//       final asr = _parseToDateTime(timings['Asr']!);
//       final maghrib = _parseToDateTime(timings['Maghrib']!);
//       final isha = _parseToDateTime(timings['Isha']!);
//       if (now.isBefore(fajr)) return "Fajr";
//       if (now.isBefore(dhuhr)) return "Dhuhr";
//       if (now.isBefore(asr)) return "Asr";
//       if (now.isBefore(maghrib)) return "Maghrib";
//       if (now.isBefore(isha)) return "Isha";
//       return "Fajr (Tomorrow)";
//     } catch (_) { return "--"; }
//   }
//
//   DateTime _parseToDateTime(String timeStr) {
//     final parts = timeStr.split(':');
//     final now = DateTime.now();
//     return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
//   }
//
//   List<Map<String, dynamic>> _getGridItems(BuildContext context) {
//     return [
//       {"icon": AllImages.allahicon, "title": "Allah", "screen": AllahNamesScreen()},
//       {"icon": AllImages.muhammadicon, "title": "Muhammad", "screen": MuhammadNameScreen()},
//       {"icon": AllImages.videoicon, "title": "Video", "screen": VideoScreen()},
//       {"icon": AllImages.tasbih, "title": "Tasbih", "screen": const TasbihScreen()},
//       {"icon": AllImages.duaicon, "title": "Dua", "screen": BlocProvider(create: (context) => AllDuaBloc(), child: const AllDuaScreen())},
//       {"icon": AllImages.zakaticon, "title": "Zakat", "screen": ZakatScreen()},
//       {"icon": AllImages.whiteCalander, "title": "Calendar", "screen": const IslamicCalendar()},
//       {"icon": AllImages.hadith, "title": "Hadith", "screen": HadithScreen()},
//       {"icon": AllImages.quranic, "title": "Quran", "screen": JuzListScreens()},
//       {"icon": AllImages.ramdhan, "title": "Ramadan", "screen": RamadanScreen()},
//     ];
//   }
//
// }
//
//
// class HiveService {
//   final String boxName = 'prayerBox';
//
//   // Data save karne ke liye
//   Future<void> saveTodayCache(PrayerCache data) async {
//     var box = await Hive.openBox<PrayerCache>(boxName);
//     await box.put('todayData', data);
//   }
//
//   // Data load karne ke liye
//   PrayerCache? loadTodayCache() {
//     var box = Hive.box<PrayerCache>(boxName);
//     return box.get('todayData');
//   }
// }

var hhhhh = 1;
// @override
// Widget build(BuildContext context) {
//   final width = MediaQuery
//       .of(context)
//       .size
//       .width;
//   SizeConfig().init(context);
//
//   return BlocProvider(
//     create: (context) =>
//     HomeBloc()
//       ..add(LoadHomeData()),
//     child: BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             centerTitle: false,
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (
//                         context) => IslamicCalendar()));
//                   },
//                   child: Row(
//                     children: [
//                       Icon(
//                           Icons.calendar_month, color: AppColors.primaryColor,
//                           size: 18),
//                       const SizedBox(width: 4),
//                       Text("Today / ${_getDayName()}",
//                           style: AppColors().customTextStyleBold16(
//                               color: AppColors.primaryColor)),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: getHeight(5)),
//                 Text('${state.gregorianDate} / ${state.hijriDate}',
//                     style: AppColors().customTextStyleCairo14(
//                         color: Colors.grey)),
//               ],
//             ),
//             actions: [
//               IconButton(
//                 onPressed: () {},
//                 //  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ListScreen())),
//                 icon: Icon(Icons.menu, color: AppColors.primaryColor),
//               ),
//             ],
//           ),
//           body: state.isLoading
//               ? Center(child: spinkit)
//               : RefreshIndicator(
//             onRefresh: () async =>
//                 context.read<HomeBloc>().add(RefreshHomeData()),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: getHeight(12)),
//                   _buildTopBanner(width, state),
//                   SizedBox(height: getHeight(20)),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 5,
//                       crossAxisSpacing: 4,
//                       mainAxisSpacing: 1,
//                       childAspectRatio: 0.78,
//                     ),
//                     itemCount: _getGridItems(context).length,
//                     itemBuilder: (context, index) {
//                       final gridItems = _getGridItems(context);
//                       return GridViewicon(
//                         icon: SvgPicture.asset(
//                             gridItems[index]["icon"], color: Colors.white,
//                             height: 32),
//                         title: gridItems[index]["title"],
//                         onclick: () =>
//                             Navigator.push(context,
//                             MaterialPageRoute(builder: (
//                                 context) => gridItems[index]["screen"])),
//                       );
//                     },
//                   ),
//                   SizedBox(height: getHeight(12)),
//                   _buildDuaSection(context),
//                   SizedBox(height: getHeight(12)),
//                   Text("Prayer Time",
//                       style: AppColors().customTextStyleBold16(
//                           color: Colors.black)),
//                   SizedBox(height: getHeight(12)),
//                   _buildPrayerTable(width, state, context),
//                   // Added context here
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }

//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final SalatTimeService _service = SalatTimeService();
//   final HiveService _hive = HiveService();
//   Timer? _timer;
//   SalatTime? _salatTime;
//   bool _isLoading = true;
//   bool _isFresh = false;
//   String _locationName = 'Loading...';
//   List<Map<String, String>> _dynamicPrayerTimes = [];
//
//   // Cache se display maps
//   Map<String, String> _cachedTimings = {};
//   Map<String, String> _cachedDisplay = {};
//
//   final List<Map<String, dynamic>> gridItems = [
//     {
//       "icon": AllImages.allahicon,
//       "title": "Allah",
//       "screen": AllahNamesScreen(),
//     },
//     {
//       "icon": AllImages.muhammadicon,
//       "title": "Muhammad",
//       "screen": MuhammadNameScreen(),
//     },
//     {
//       "icon": AllImages.videoicon, "title": "Video", "screen": VideoScreen(),
//       // const QiblaScreen()
//     },
//     {
//       "icon": AllImages.tasbih,
//       "title": "Tasbih",
//       "screen": const TasbihScreen(),
//     },
//     {
//       "icon": AllImages.duaicon,
//       "title": "Dua",
//       "screen": BlocProvider(
//         create: (context) => AllDuaBloc(),
//         child: const AllDuaScreen(),
//       ),
//     },
//     {"icon": AllImages.zakaticon, "title": "Zakat", "screen": ZakatScreen()},
//     {
//       "icon": AllImages.whiteCalander,
//       "title": "Calendar",
//       "screen": const IslamicCalendar(),
//     },
//     {"icon": AllImages.hadith, "title": "Hadith", "screen": HadithScreen()},
//     {"icon": AllImages.quranic, "title": "Quran", "screen": JuzListScreens()},
//     //QuranPakScreen()},
//     //MyHomePage(title: 'Local Notifications')},
//     {"icon": AllImages.ramdhan, "title": "Ramadan", "screen": RamadanScreen()},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     _loadData();
//     // Har minute UI update karein taaki 'Now' change ho sake
//     _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
//       if (mounted) setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel(); // Timer band karna zaroori hai
//     super.dispose();
//   }
//   // ─── Data Loading ──────────────────────────────────────────
//
//   Future<void> _loadData() async {
//     // STEP 1: Hive cache check karo
//     final cache = _hive.loadTodayCache();
//
//     if (cache != null) {
//       // Cache mila — foran dikhao, no spinner
//       _applyCache(cache);
//       setState(() => _isLoading = false);
//
//       // STEP 2: Background mein quietly update
//       _fetchFreshInBackground();
//     } else {
//       // Cache nahi — spinner dikhao, API se fetch karo
//       setState(() => _isLoading = true);
//       await _fetchAndSave();
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _applyCache(PrayerCache cache) {
//     if (!mounted) return;
//
//     _cachedTimings = {
//       'Fajr': cache.fajr,
//       'Dhuhr': cache.dhuhr,
//       'Asr': cache.asr,
//       'Maghrib': cache.maghrib,
//       'Isha': cache.isha,
//     };
//     _cachedDisplay = {
//       'hijriDay': cache.hijriDay,
//       'hijriMonth': cache.hijriMonth,
//       'hijriYear': cache.hijriYear,
//       'gregorianReadable': cache.gregorianReadable,
//     };
//
//     setState(() {
//       _locationName = cache.locationName;
//       _isFresh = false;
//       _dynamicPrayerTimes = _buildPrayerList(_cachedTimings);
//     });
//   }
//
//   Future<void> _fetchFreshInBackground() async {
//     try {
//       await _fetchAndSave(silent: true);
//     } catch (_) {}
//   }
//
//   Future<void> _fetchAndSave({bool silent = false}) async {
//     final result = await _service.fetchPrayerTimes();
//     if (!mounted) return;
//
//     if (result.salatTime != null) {
//       // Hive mein save karo
//       final cache = _buildCache(result);
//       await _hive.savePrayerCache(cache);
//
//       final timings = result.salatTime!.data?.timings;
//       final timingMap = {
//         'Fajr': _cleanTime(timings?.fajr),
//         'Dhuhr': _cleanTime(timings?.dhuhr),
//         'Asr': _cleanTime(timings?.asr),
//         'Maghrib': _cleanTime(timings?.maghrib),
//         'Isha': _cleanTime(timings?.isha),
//       };
//       // _fetchAndSave ke andar setState ko aise update karein:
//       setState(() {
//         _salatTime = result.salatTime;
//         _locationName = result.locationName;
//         _isFresh = true;
//         // Khali karne ki bajaye fresh data se bhar dein
//         _cachedTimings = timingMap;
//         _dynamicPrayerTimes = _buildPrayerList(timingMap);
//       });
//       // setState(() {
//       //   _salatTime    = result.salatTime;
//       //   _locationName = result.locationName;
//       //   _isFresh      = true;
//       //   _cachedTimings = {};
//       //   _cachedDisplay = {};
//       //   _dynamicPrayerTimes = _buildPrayerList(timingMap);
//       // });
//     } else if (!silent) {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   // ─── Prayer List Builder ───────────────────────────────────
//
//   List<Map<String, String>> _buildPrayerList(Map<String, String> timings) {
//     return [
//       {
//         'Prayer': 'Fajr',
//         'Adhun': _formatTime(timings['Fajr']),
//         'Iqama': _calculateIqama(timings['Fajr'], 20),
//       },
//       {
//         'Prayer': 'Dhuhr',
//         'Adhun': _formatTime(timings['Dhuhr']),
//         'Iqama': _calculateIqama(timings['Dhuhr'], 15),
//       },
//       {
//         'Prayer': 'Asr',
//         'Adhun': _formatTime(timings['Asr']),
//         'Iqama': _calculateIqama(timings['Asr'], 15),
//       },
//       {
//         'Prayer': 'Maghrib',
//         'Adhun': _formatTime(timings['Maghrib']),
//         'Iqama': _calculateIqama(timings['Maghrib'], 5),
//       },
//       {
//         'Prayer': 'Isha',
//         'Adhun': _formatTime(timings['Isha']),
//         'Iqama': _calculateIqama(timings['Isha'], 15),
//       },
//     ];
//   }
//
//   // ─── Cache Builder ─────────────────────────────────────────
//
//   PrayerCache _buildCache(SalatTimeResult result) {
//     final timings = result.salatTime?.data?.timings;
//     final hijri = result.salatTime?.data?.date?.hijri;
//     final greg = result.salatTime?.data?.date?.gregorian;
//     final timezone = result.salatTime?.data?.meta?.timezone ?? 'Asia/Karachi';
//     final now = DateTime.now();
//
//     return PrayerCache(
//       fajr: _cleanTime(timings?.fajr),
//       dhuhr: _cleanTime(timings?.dhuhr),
//       asr: _cleanTime(timings?.asr),
//       maghrib: _cleanTime(timings?.maghrib),
//       isha: _cleanTime(timings?.isha),
//       locationName: result.locationName,
//       isFromGPS: result.isFromGPS,
//       hijriDay: hijri?.day ?? '',
//       hijriMonth: hijri?.month?.ar ?? hijri?.month?.en ?? '',
//       hijriYear: hijri?.year ?? '',
//       hijriDesignation: hijri?.designation?.abbreviated ?? 'AH',
//       gregorianReadable: greg?.readable ?? '',
//       hijriWeekday: hijri?.weekday?.ar ?? '',
//       timezone: timezone,
//       savedDate: '${now.day}-${now.month}-${now.year}',
//     );
//   }
//
//   // ─── Time Helpers ──────────────────────────────────────────
//
//   String _cleanTime(String? raw) {
//     if (raw == null) return '--:--';
//     return raw.split(' ').first;
//   }
//
//   String _formatTime(String? raw) {
//     if (raw == null || raw == '--:--') return '--:--';
//     try {
//       final parts = raw.split(':');
//       int hour = int.parse(parts[0]);
//       final minute = int.parse(parts[1]);
//       final period = hour >= 12 ? 'PM' : 'AM';
//       if (hour > 12) hour -= 12;
//       if (hour == 0) hour = 12;
//       return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
//     } catch (_) {
//       return raw;
//     }
//   }
//
//   String _calculateIqama(String? rawAdhan, int minutesToAdd) {
//     if (rawAdhan == null || rawAdhan == '--:--') return '--:--';
//     try {
//       final parts = rawAdhan.split(':');
//       final now = DateTime.now();
//       var time = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         int.parse(parts[0]),
//         int.parse(parts[1]),
//       );
//       time = time.add(Duration(minutes: minutesToAdd));
//
//       int hour = time.hour;
//       final minute = time.minute;
//       final period = hour >= 12 ? 'PM' : 'AM';
//       if (hour > 12) hour -= 12;
//       if (hour == 0) hour = 12;
//       return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
//     } catch (_) {
//       return '--:--';
//     }
//   }
//
//   // ─── Display Getters ───────────────────────────────────────
//
//   String get _hijriDateText {
//     if (_isFresh && _salatTime != null) {
//       final h = _salatTime!.data?.date?.hijri;
//       return '${h?.day ?? ''} ${h?.month?.en ?? ''} ${h?.year ?? ''} AH';
//     }
//     final d = _cachedDisplay;
//     return '${d['hijriDay'] ?? ''} ${d['hijriMonth'] ?? ''} ${d['hijriYear'] ?? ''} AH';
//   }
//
//   String get _gregorianDateText {
//     if (_isFresh && _salatTime != null) {
//       return _salatTime!.data?.date?.gregorian?.readable ?? '';
//     }
//     return _cachedDisplay['gregorianReadable'] ?? '';
//   }
//
//   // ─── Build ─────────────────────────────────────────────────
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     SizeConfig().init(context);
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => IslamicCalendar()),
//                 );
//               },
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.calendar_month,
//                     color: AppColors.primaryColor,
//                     size: 18,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     "Today / ${_getDayName()}",
//                     style: AppColors().customTextStyleBold16(
//                       color: AppColors.primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: getHeight(5)),
//             Text(
//               '$_gregorianDateText / $_hijriDateText',
//               style: AppColors().customTextStyleCairo14(color: Colors.grey),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const ListScreen()),
//             ),
//             icon: Icon(Icons.menu, color: AppColors.primaryColor),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: spinkit)
//           : RefreshIndicator(
//               onRefresh: () => _fetchAndSave(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: getHeight(12)),
//                     _buildTopBanner(width),
//                     SizedBox(height: getHeight(20)),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 5,
//                             crossAxisSpacing: 4,
//                             mainAxisSpacing: 1,
//                             childAspectRatio: 0.78,
//                           ),
//                       itemCount: gridItems.length,
//                       itemBuilder: (context, index) {
//                         return GridViewicon(
//                           icon: SvgPicture.asset(
//                             gridItems[index]["icon"],
//                             color: Colors.white,
//                             height: 32,
//                           ),
//                           title: gridItems[index]["title"],
//                           onclick: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => gridItems[index]["screen"],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(height: getHeight(12)),
//                     _buildDuaSection(),
//                     SizedBox(height: getHeight(12)),
//                     Text(
//                       "Prayer Time",
//                       style: AppColors().customTextStyleBold16(
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: getHeight(12)),
//                     _buildPrayerTable(width),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
//
//   // ─── Widgets ───────────────────────────────────────────────
//
//   Widget _buildTopBanner(double width) {
//     return Container(
//       height: getHeight(148),
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: AppColors.primaryColor,
//         image: DecorationImage(
//           image: AssetImage(AllImages.containerBackground),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _bannerText(AllText.now, _getCurrentPrayerName()),
//                 _bannerText(AllText.upcoming, _getUpcomingPrayerName()),
//                 _bannerText("Location", _locationName),
//               ],
//             ),
//           ),
//           SvgPicture.asset(AllImages.quranpak, height: getHeight(150)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPrayerTable(double width) {
//     return Expanded(
//       child: Container(
//         width: width,
//         height: getHeight(220),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: DecorationImage(
//             image: AssetImage(AllImages.prayertimebackground),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Theme(
//             data: Theme.of(context).copyWith(
//               dividerColor: Colors.transparent, // ✅ line color
//             ),
//             child: DataTable(
//               columnSpacing: width * 0.12,
//               horizontalMargin: 15,
//               headingRowHeight: 45,
//               dividerThickness: 0.01,
//               // ✅ thickness
//               columns: const [
//                 DataColumn(
//                   label: Text(
//                     'Prayer',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'Adhan',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'Iqama',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//               rows: _dynamicPrayerTimes
//                   .map(
//                     (time) => DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             time['Prayer']!,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             time['Adhun']!,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             time['Iqama']!,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _getDayName() => [
//     "Monday",
//     "Tuesday",
//     "Wednesday",
//     "Thursday",
//     "Friday",
//     "Saturday",
//     "Sunday",
//   ][DateTime.now().weekday - 1];
//
//   Widget _bannerText(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: AppColors().customTextStyleRegular10(
//             color: AppColors.white,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         SizedBox(height: getHeight(2)),
//         Text(
//           value,
//           style: AppColors().customTextStyle12(
//             color: AppColors.white,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: getHeight(4)),
//       ],
//     );
//   }
//
//   DateTime _parseToDateTime(String timeStr) {
//     final parts = timeStr.split(':');
//     final now = DateTime.now();
//     return DateTime(
//       now.year,
//       now.month,
//       now.day,
//       int.parse(parts[0]),
//       int.parse(parts[1]),
//     );
//   }
//
//   String _getCurrentPrayerName() {
//     if (_cachedTimings.isEmpty) return "--";
//
//     final now = DateTime.now();
//
//     // Timings ko DateTime mein convert karein
//     final fajr = _parseToDateTime(_cachedTimings['Fajr']!);
//     final dhuhr = _parseToDateTime(_cachedTimings['Dhuhr']!);
//     final asr = _parseToDateTime(_cachedTimings['Asr']!);
//     final maghrib = _parseToDateTime(_cachedTimings['Maghrib']!);
//     final isha = _parseToDateTime(_cachedTimings['Isha']!);
//
//     if (now.isAfter(fajr) && now.isBefore(dhuhr)) return "Fajr";
//     if (now.isAfter(dhuhr) && now.isBefore(asr)) return "Dhuhr";
//     if (now.isAfter(asr) && now.isBefore(maghrib)) return "Asr";
//     if (now.isAfter(maghrib) && now.isBefore(isha)) return "Maghrib";
//
//     // Isha se Fajr tak ka waqt
//     return "Isha";
//   }
//
//   String _getUpcomingPrayerName() {
//     if (_cachedTimings.isEmpty) return "--";
//
//     final now = DateTime.now();
//
//     final fajr = _parseToDateTime(_cachedTimings['Fajr']!);
//     final dhuhr = _parseToDateTime(_cachedTimings['Dhuhr']!);
//     final asr = _parseToDateTime(_cachedTimings['Asr']!);
//     final maghrib = _parseToDateTime(_cachedTimings['Maghrib']!);
//     final isha = _parseToDateTime(_cachedTimings['Isha']!);
//
//     if (now.isBefore(fajr)) return "Fajr";
//     if (now.isBefore(dhuhr)) return "Dhuhr";
//     if (now.isBefore(asr)) return "Asr";
//     if (now.isBefore(maghrib)) return "Maghrib";
//     if (now.isBefore(isha)) return "Isha";
//
//     // Agar Isha ke baad ka waqt hai to agli namaz kal ki Fajr hogi
//     return "Fajr (Tomorrow)";
//   }
//
//   Widget _buildDuaSection() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text("Daily Dua", style: AppColors().customTextStyleBold16()),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AllDuaScreen()),
//                 );
//               },
//               child: Text(
//                 "See All",
//                 style: TextStyle(color: AppColors.primaryColor, fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         AllDuaCard(showLeftLine: false),
//       ],
//     );
//   }
// }
