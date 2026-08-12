import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:local_notification/AllApiLink/AllApiLink.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/userFeedback.dart';
import 'package:local_notification/services/prayer_azan_service.dart';
import 'package:switcher_button/switcher_button.dart' show SwitcherButton;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../../Model/PrayerCacheModel.dart';
import '../../Model/PrayerModel.dart';
import '../../Utils/Constants/ShimmerUI.dart';
import '../../Utils/Constants/SizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LocalStorageService {
  Future<void> saveSwitchState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> getSwitchState(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}

class SalatTimeResult {
  final SalatTime? salatTime;
  final String locationName;
  final bool isFromGPS;
  final String? errorMessage;

  SalatTimeResult({
    required this.salatTime,
    required this.locationName,
    required this.isFromGPS,
    this.errorMessage,
  });
}

class SalatTimeService {
  Future<Position?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        final serviceNowEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceNowEnabled) return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.deniedForever) return null;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      try {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          final age = DateTime.now().difference(lastKnown.timestamp);
          if (age.inMinutes < 30) return lastKnown;
        }
      } catch (_) {}

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('GPS timeout after 15s'),
      );
    } on TimeoutException {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    } catch (e) {
      debugPrint('❌ Location error: $e');
      return null;
    }
  }

  Future<SalatTime?> getPrayerTimesByCoords({
    required double latitude,
    required double longitude,
    int method = 1,
  }) async {
    try {
      final now = DateTime.now();
      final date = '${now.day}-${now.month}-${now.year}';
      final uri = Uri.parse(
        '${AllApiLink.prayerTime}/$date'
            '?latitude=$latitude&longitude=$longitude&method=$method',
      );
      final response =
          await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return SalatTime.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<SalatTimeResult> fetchPrayerTimes() async {
    final position = await getCurrentLocation();

    if (position == null) {
      final data = await _fallbackIslamabad();
      return SalatTimeResult(
        salatTime: data,
        locationName: 'Islamabad, Pakistan',
        isFromGPS: false,
        errorMessage: 'Location access not available.',
      );
    }

    final salatTime = await getPrayerTimesByCoords(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    final locationName = await _getLocationName(
      position.latitude,
      position.longitude,
    );

    if (salatTime == null) {
      final data = await _fallbackIslamabad();
      return SalatTimeResult(
        salatTime: data,
        locationName: 'Islamabad, Pakistan',
        isFromGPS: false,
        errorMessage: 'Failed to fetch data from the server.',
      );
    }

    return SalatTimeResult(
      salatTime: salatTime,
      locationName: locationName,
      isFromGPS: true,
    );
  }

  Future<SalatTime?> _fallbackIslamabad() =>
      getPrayerTimesByCoords(latitude: 33.6844, longitude: 73.0479);

  Future<String> _getLocationName(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality?.isNotEmpty == true
            ? place.locality!
            : place.subLocality?.isNotEmpty == true
                ? place.subLocality!
                : place.subAdministrativeArea?.isNotEmpty == true
                    ? place.subAdministrativeArea!
                    : place.administrativeArea?.isNotEmpty == true
                        ? place.administrativeArea!
                        : '';
        final country = place.country ?? '';
        debugPrint('📍 city: $city, country: $country');
        if (city.isNotEmpty && country.isNotEmpty) return '$city, $country';
        if (country.isNotEmpty) return country;
      }
    } catch (e) {
      debugPrint('❌ Geocoding error: $e');
    }
    return 'Your Location';
  }
}

class PrayerTimeState {
  final bool isLoading;
  final bool isFresh;
  final bool isFromGPS;
  final String locationName;
  final String timezone;
  final String? errorMessage;
  final Map<String, bool> switchStates;
  final SalatTime? salatTime;
  final Map<String, String> cachedTimings;
  final Map<String, String> cachedDisplay;

  PrayerTimeState({
    this.isLoading = true,
    this.isFresh = false,
    this.isFromGPS = false,
    this.locationName = '',
    this.timezone = 'Asia/Karachi',
    this.errorMessage,
    this.switchStates = const {},
    this.salatTime,
    this.cachedTimings = const {},
    this.cachedDisplay = const {},
  });

  PrayerTimeState copyWith({
    bool? isLoading,
    bool? isFresh,
    bool? isFromGPS,
    String? locationName,
    String? timezone,
    String? errorMessage,
    Map<String, bool>? switchStates,
    SalatTime? salatTime,
    Map<String, String>? cachedTimings,
    Map<String, String>? cachedDisplay,
  }) {
    return PrayerTimeState(
      isLoading: isLoading ?? this.isLoading,
      isFresh: isFresh ?? this.isFresh,
      isFromGPS: isFromGPS ?? this.isFromGPS,
      locationName: locationName ?? this.locationName,
      timezone: timezone ?? this.timezone,
      errorMessage: errorMessage ?? this.errorMessage,
      switchStates: switchStates ?? this.switchStates,
      salatTime: salatTime ?? this.salatTime,
      cachedTimings: cachedTimings ?? this.cachedTimings,
      cachedDisplay: cachedDisplay ?? this.cachedDisplay,
    );
  }
}

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  final SalatTimeService _service = SalatTimeService();
  final HiveService _hive = HiveService();
  final PrayerAzanService _azanService = PrayerAzanService();

  PrayerTimeCubit() : super(PrayerTimeState());

  void init() {
    _loadSwitchStates();
    _loadInitialData();
  }

  void _loadSwitchStates() {
    final Map<String, bool> loaded = {};
    for (final name in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
      loaded[name] = _hive.getSwitchState(name);
    }
    emit(state.copyWith(switchStates: loaded));
  }

  Future<void> _loadInitialData() async {
    final cache = _hive.loadTodayCache();
    if (cache != null) {
      _applyCache(cache);
      fetchAndSave(silent: true);
    } else {
      fetchAndSave();
    }
  }

  void _applyCache(PrayerCache cache) {
    emit(state.copyWith(
      isLoading: false,
      locationName: cache.locationName,
      isFromGPS: cache.isFromGPS,
      timezone: cache.timezone,
      isFresh: false,
      cachedTimings: {
        'Fajr': cache.fajr,
        'Dhuhr': cache.dhuhr,
        'Asr': cache.asr,
        'Maghrib': cache.maghrib,
        'Isha': cache.isha,
      },
      cachedDisplay: {
        'hijriWeekday': cache.hijriWeekday,
        'hijriDate':
            '${cache.hijriDay} ${cache.hijriMonth} ${cache.hijriYear} ${cache.hijriDesignation}',
        'gregorianReadable': cache.gregorianReadable,
      },
    ));
  }

  Future<void> fetchAndSave({bool silent = false}) async {
    if (!silent) emit(state.copyWith(isLoading: true));
    final result = await _service.fetchPrayerTimes();

    if (result.salatTime != null) {
      final cache = _buildCache(result);
      await _hive.savePrayerCache(cache);
      emit(state.copyWith(
        isLoading: false,
        salatTime: result.salatTime,
        locationName: result.locationName,
        isFromGPS: result.isFromGPS,
        errorMessage: result.errorMessage,
        timezone: result.salatTime?.data?.meta?.timezone ?? 'Asia/Karachi',
        isFresh: true,
        cachedTimings: {},
        cachedDisplay: {},
      ));

      await _rescheduleActiveAzans();
    } else if (!silent) {
      emit(state.copyWith(
          isLoading: false, errorMessage: result.errorMessage));
    }
  }

  Future<void> _rescheduleActiveAzans() async {
    for (final name in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
      if (state.switchStates[name] == true) {
        final rawTime = _getRawTimeForName(name);
        if (rawTime.isNotEmpty && rawTime != '--:--') {
          await _azanService.scheduleAzan(
            prayerName: name,
            rawTime: rawTime,
          );
        }
      }
    }
  }

  String _getRawTimeForName(String name) {
    final t = state.salatTime?.data?.timings;
    switch (name) {
      case 'Fajr':
        return t?.fajr?.split(' ').first ?? '';
      case 'Dhuhr':
        return t?.dhuhr?.split(' ').first ?? '';
      case 'Asr':
        return t?.asr?.split(' ').first ?? '';
      case 'Maghrib':
        return t?.maghrib?.split(' ').first ?? '';
      case 'Isha':
        return t?.isha?.split(' ').first ?? '';
      default:
        return '';
    }
  }

  // ── Switch toggle — azan schedule ya cancel ───────────────────
  Future<void> onSwitchChanged(
      String name, bool value, String rawTime) async {
    final newStates = Map<String, bool>.from(state.switchStates);
    newStates[name] = value;
    emit(state.copyWith(switchStates: newStates));
    await _hive.saveSwitchState(name, value);

    if (value) {
      // await _azanService.testAzan(name);  
      await _azanService.scheduleAzan(
        prayerName: name,
        rawTime: rawTime,
      );
    } else {
      await _azanService.cancelAzan(name);
    }
  }

  PrayerCache _buildCache(SalatTimeResult result) {
    final timings = result.salatTime?.data?.timings;
    final h = result.salatTime?.data?.date?.hijri;
    return PrayerCache(
      fajr: timings?.fajr?.split(' ').first ?? '',
      dhuhr: timings?.dhuhr?.split(' ').first ?? '',
      asr: timings?.asr?.split(' ').first ?? '',
      maghrib: timings?.maghrib?.split(' ').first ?? '',
      isha: timings?.isha?.split(' ').first ?? '',
      locationName: result.locationName,
      isFromGPS: result.isFromGPS,
      hijriDay: h?.day ?? '',
      hijriMonth: h?.month?.en ?? '',
      hijriYear: h?.year ?? '',
      hijriDesignation: h?.designation?.abbreviated ?? 'AH',
      gregorianReadable:
          result.salatTime?.data?.date?.gregorian?.readable ?? '',
      hijriWeekday: h?.weekday?.en ?? '',
      timezone: result.salatTime?.data?.meta?.timezone ?? 'Asia/Karachi',
      savedDate: DateTime.now().toString(),
    );
  }
}

class PrayerTimeScreen extends StatelessWidget {
  const PrayerTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => PrayerTimeCubit()..init(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(AllText.prayerstime,
                  style: AppColors().customTextStyleBold16()),
              SizedBox(height: getHeight(5)),
              Text(
                AllText.accuratetime,
                style: AppColors().customTextStyle14(
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context
                    .read<PrayerTimeCubit>()
                    .fetchAndSave(silent: true),
              );
            }),
          ],
        ),
        body: BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
          builder: (context, state) {
            if (state.isLoading && state.cachedTimings.isEmpty) {
              return _buildShimmerEffect(width);
            }

            final hijriWeekday = state.isFresh
                ? (state.salatTime?.data?.date?.hijri?.weekday?.ar ?? '')
                : (state.cachedDisplay['hijriWeekday'] ?? '');

            final hijriDate = state.isFresh
                ? _getLiveHijriDate(state.salatTime)
                : (state.cachedDisplay['hijriDate'] ?? '');

            final gregorianReadable = state.isFresh
                ? (state.salatTime?.data?.date?.gregorian?.readable ?? '')
                : (state.cachedDisplay['gregorianReadable'] ?? '');

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<PrayerTimeCubit>().fetchAndSave(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
                  child: Column(
                    children: [
                      if (state.errorMessage != null &&
                          state.errorMessage!.isNotEmpty)
                        _errorWidget(state.errorMessage!),
                      SizedBox(height: getHeight(12)),
                      _headerCard(state, hijriWeekday, hijriDate,
                          gregorianReadable),
                      SizedBox(height: getHeight(12)),
                      ...['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']
                          .map((name) {
                        final rawTime = _getRawTime(state, name);
                        return PrayerTimeCard(
                          title: name,
                          time: _formatTime(rawTime),
                          rawTime: rawTime,
                          image: _getImage(name),
                          timezone: state.timezone,
                          isOn: state.switchStates[name],
                          onChanged: (val) {
                            context
                                .read<PrayerTimeCubit>()
                                .onSwitchChanged(name, val, rawTime);
                           if (val) {
                          showSuccessToast(context, '✅ $name azan scheduled');
                            } else {
                          showErrorToast(context, '🔕 $name azan cancelled');
}
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerEffect(double width) {
    return Scaffold(
      appBar: AppBar(
          title: AppShimmer(width: width * 0.5, height: getHeight(20))),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
        child: Column(
          children: [
            SizedBox(height: getHeight(12)),
            AppShimmer(width: width),
            SizedBox(height: getHeight(20)),
            Column(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppShimmer(
                      width: double.infinity, height: getHeight(80)),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  String _getLiveHijriDate(SalatTime? salatTime) {
    final h = salatTime?.data?.date?.hijri;
    if (h == null) return '';
    return '${h.day} ${h.month?.ar ?? h.month?.en ?? ''} ${h.year} ${h.designation?.abbreviated ?? 'AH'}';
  }

  Widget _errorWidget(String message) {
    return Container(
      margin: EdgeInsets.only(bottom: getHeight(10)),
      padding: EdgeInsets.symmetric(
          horizontal: getWidth(12), vertical: getHeight(8)),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.location_off,
              color: Colors.orange.shade700, size: 18),
          SizedBox(width: getWidth(8)),
          Expanded(
            child: Text(message,
                style: TextStyle(
                    color: Colors.orange.shade800, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _headerCard(PrayerTimeState state, String weekday, String date,
      String greg) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: getHeight(20)),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
              state.isFromGPS
                  ? Icons.location_on
                  : Icons.location_city,
              color: Colors.white70,
              size: 14),
          SizedBox(width: getWidth(4)),
          Text(state.locationName,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
        SizedBox(height: getHeight(8)),
        Text(weekday, style: AppColors().customTextStyleCairo14()),
        SizedBox(height: getHeight(8)),
        Text(date,
            style: AppColors().customTextStyleCairo30(),
            textAlign: TextAlign.center),
        SizedBox(height: getHeight(8)),
        Text(greg, style: AppColors().customTextStyleCairo14()),
      ]),
    );
  }

  String _getRawTime(PrayerTimeState state, String name) {
    if (state.isFresh && state.salatTime != null) {
      final t = state.salatTime!.data?.timings;
      switch (name) {
        case 'Fajr':
          return t?.fajr?.split(' ').first ?? '';
        case 'Dhuhr':
          return t?.dhuhr?.split(' ').first ?? '';
        case 'Asr':
          return t?.asr?.split(' ').first ?? '';
        case 'Maghrib':
          return t?.maghrib?.split(' ').first ?? '';
        case 'Isha':
          return t?.isha?.split(' ').first ?? '';
      }
    }
    return state.cachedTimings[name] ?? '--:--';
  }

  String _formatTime(String raw) {
    try {
      final parts = raw.split(':');
      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return raw;
    }
  }

  String _getImage(String name) {
    switch (name) {
      case 'Fajr':
        return AllImages.fajrIcon;
      case 'Dhuhr':
        return AllImages.zohrIcon;
      case 'Asr':
        return AllImages.asrIcon;
      case 'Maghrib':
        return AllImages.magribIcon;
      case 'Isha':
        return AllImages.ishaIcon;
      default:
        return AllImages.fajrIcon;
    }
  }
}

class PrayerTimeCard extends StatelessWidget {
  final String title;
  final String time;
  final String rawTime;
  final String image;
  final String timezone;
  final bool? isOn;
  final ValueChanged<bool> onChanged;

  const PrayerTimeCard({
    super.key,
    required this.title,
    required this.time,
    required this.rawTime,
    required this.image,
    required this.timezone,
    this.isOn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool switchValue = isOn ?? false;
    return Container(
      margin: EdgeInsets.symmetric(vertical: getHeight(8)),
      padding: EdgeInsets.symmetric(
          horizontal: getWidth(12), vertical: getHeight(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: getWidth(28),
            backgroundColor: Colors.grey.shade100,
            child: SvgPicture.asset(image,
                color: switchValue ? Colors.teal : Colors.black),
          ),
          SizedBox(width: getWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: AppColors().customTextStyleBold16()),
                SizedBox(height: getHeight(10),),
                Icon(
                    switchValue
                        ? Icons.notifications_active
                        : Icons.notifications_none,
                    size: 20,
                    color: switchValue ? Colors.teal : Colors.grey),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(time, style: AppColors().customTextStyle14()),
              SizedBox(height: getHeight(5)),
              SwitcherButton(
                value: switchValue,
                size: 45,
                offColor: Colors.grey,
                onColor: AppColors.primaryColor,
                onChange: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}