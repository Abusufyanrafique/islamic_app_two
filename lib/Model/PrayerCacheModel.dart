// ============================================================
// prayer_cache.dart — Hive Model
// ============================================================
import 'package:hive/hive.dart';
// ============================================================
// hive_service.dart
// ============================================================
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_notification/Model/prayerSwitchModel.dart';
part 'PrayerCacheModel.g.dart';

@HiveType(typeId: 0)
class PrayerCache extends HiveObject {
  @HiveField(0)
  String fajr;

  @HiveField(1)
  String dhuhr;

  @HiveField(2)
  String asr;

  @HiveField(3)
  String maghrib;

  @HiveField(4)
  String isha;

  @HiveField(5)
  String locationName;

  @HiveField(6)
  bool isFromGPS;

  @HiveField(7)
  String hijriDay;

  @HiveField(8)
  String hijriMonth;

  @HiveField(9)
  String hijriYear;

  @HiveField(10)
  String hijriDesignation;

  @HiveField(11)
  String gregorianReadable;

  @HiveField(12)
  String hijriWeekday;

  @HiveField(13)
  String timezone;

  @HiveField(14)
  String savedDate; // Jis din ka data hai
  @HiveField(15)
  double latitude;

  @HiveField(16)
  double longitude;

  PrayerCache({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.locationName,
    required this.isFromGPS,
    required this.hijriDay,
    required this.hijriMonth,
    required this.hijriYear,
    required this.hijriDesignation,
    required this.gregorianReadable,
    required this.hijriWeekday,
    required this.timezone,
    required this.savedDate,
    this.latitude  = 0.0,  // ← default value
    this.longitude = 0.0,
  });
}


class HiveService {
  static const String _prayerBox = 'prayer_cache';
  static const String _switchBox = 'prayer_switches';
  static const String _cacheKey  = 'today_prayers';
  static const String _switchKey = 'switch_states';


  // ─── Init (main.dart mein call karo) ───────────────────────
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PrayerCacheAdapter());
    Hive.registerAdapter(PrayerSwitchStateAdapter());
    await Hive.openBox<PrayerCache>(_prayerBox);
    await Hive.openBox<PrayerSwitchState>(_switchBox);
  }
// HiveService mein yeh add karo

  /// Last known coordinates save karo
  Future<void> saveLocation(double lat, double lng) async {
    final box = Hive.box<PrayerCache>(_prayerBox);
    final cache = box.get(_cacheKey);
    if (cache != null) {
      cache.latitude  = lat;
      cache.longitude = lng;
      await cache.save();
    } else {
      // Sirf location wala minimal cache save karo
      await box.put(
        'location_only',
        PrayerCache(
          fajr: '', dhuhr: '', asr: '', maghrib: '', isha: '',
          locationName: '', isFromGPS: true,
          hijriDay: '', hijriMonth: '', hijriYear: '',
          hijriDesignation: '', gregorianReadable: '',
          hijriWeekday: '', timezone: '',
          savedDate: '',
          latitude: lat,
          longitude: lng,
        ),
      );
    }
  }

  /// Last saved coordinates load karo
  Map<String, double>? loadSavedLocation() {
    final box = Hive.box<PrayerCache>(_prayerBox);

    // Pehle today cache se try karo
    final cache = box.get(_cacheKey);
    if (cache != null && cache.latitude != 0.0 && cache.longitude != 0.0) {
      return {'lat': cache.latitude, 'lng': cache.longitude};
    }

    // location_only se try karo
    final locOnly = box.get('location_only');
    if (locOnly != null && locOnly.latitude != 0.0) {
      return {'lat': locOnly.latitude, 'lng': locOnly.longitude};
    }

    return null;
  }
  // ─── Prayer Cache ───────────────────────────────────────────

  /// Cache save karo
  Future<void> savePrayerCache(PrayerCache cache) async {
    final box = Hive.box<PrayerCache>(_prayerBox);
    await box.put(_cacheKey, cache);
  }

  /// Cache load karo — null agar nahi hai ya purana din ka hai
  PrayerCache? loadTodayCache() {
    final box = Hive.box<PrayerCache>(_prayerBox);
    final cache = box.get(_cacheKey);
    if (cache == null) return null;

    // Aaj ka date check karo — purana data use mat karo
    final today = _todayKey();
    if (cache.savedDate != today) {
      box.delete(_cacheKey); // purana delete karo
      return null;
    }
    return cache;
  }

  // ─── Switch States ──────────────────────────────────────────

  /// Switch state save karo
  Future<void> saveSwitchState(String prayerName, bool value) async {
    final box = Hive.box<PrayerSwitchState>(_switchBox);
    final current = box.get(_switchKey) ?? PrayerSwitchState();
    _setSwitchValue(current, prayerName, value);
    await box.put(_switchKey, current);
  }

  /// Saari switch states load karo
  PrayerSwitchState loadSwitchStates() {
    final box = Hive.box<PrayerSwitchState>(_switchBox);
    return box.get(_switchKey) ?? PrayerSwitchState();
  }

  /// Switch state get karo individual
  bool getSwitchState(String prayerName) {
    final states = loadSwitchStates();
    return _getSwitchValue(states, prayerName);
  }

  // ─── Helpers ────────────────────────────────────────────────

  String _todayKey() {
    final now = DateTime.now();
    return '${now.day}-${now.month}-${now.year}';
  }

  void _setSwitchValue(PrayerSwitchState state, String name, bool value) {
    switch (name) {
      case 'Fajr':    state.fajr    = value; break;
      case 'Dhuhr':   state.dhuhr   = value; break;
      case 'Asr':     state.asr     = value; break;
      case 'Maghrib': state.maghrib = value; break;
      case 'Isha':    state.isha    = value; break;
    }
  }

  bool _getSwitchValue(PrayerSwitchState state, String name) {
    switch (name) {
      case 'Fajr':    return state.fajr;
      case 'Dhuhr':   return state.dhuhr;
      case 'Asr':     return state.asr;
      case 'Maghrib': return state.maghrib;
      case 'Isha':    return state.isha;
      default:        return false;
    }
  }
}