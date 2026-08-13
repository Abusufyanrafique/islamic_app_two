import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:audio_service/audio_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_notification/SupaBase/SupabaseConstant.dart';
import 'package:local_notification/View/splash_screen/splash_screen.dart';
import 'package:local_notification/services/notification_service.dart';
import 'package:local_notification/services/prayer_azan_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'Model/PrayerCacheModel.dart';
import 'View/Home/subScreen/AllDuaScreen.dart';
import 'View/QuranScreen/QuranScreen.dart';

late QuranAudioHandler audioHandler;

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {

    // 1️⃣ SABSE PEHLE — Flutter binding
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint("STEP 1: WidgetsFlutterBinding done");

    // 2️⃣ DOOSRA — Timezone (PrayerAzan se pehle ZARURI)
    try {
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
      debugPrint("STEP 2: Timezone init done");
    } catch (e, st) {
      debugPrint("‼️ STEP 2 FAILED (timezone): $e");
      debugPrint("$st");
    }

    // 3️⃣ TEESRA — Bookmark
    try {
      await BookmarkManager.instance.init();
      debugPrint("STEP 3: BookmarkManager done");
    } catch (e, st) {
      debugPrint("‼️ STEP 3 FAILED (bookmark): $e");
      debugPrint("$st");
    }

    // 4️⃣ CHAUTHA — Prayer Azan (timezone ke BAAD)
    try {
      await PrayerAzanService.init();
      debugPrint("STEP 4: PrayerAzanService done");
    } catch (e, st) {
      debugPrint("‼️ STEP 4 FAILED (prayer azan): $e");
      debugPrint("$st");
    }

    // 5️⃣ PAANCHWA — Notification Service
    try {
      await NotificationService1().initNotification();
      debugPrint("STEP 5: NotificationService done");
    } catch (e, st) {
      debugPrint("‼️ STEP 5 FAILED (notification): $e");
      debugPrint("$st");
    }

    // 6️⃣ CHHATA — Supabase
    try {
      await Supabase.initialize(url: appUrl, anonKey: appKey);
      debugPrint("STEP 6: Supabase done");
    } catch (e, st) {
      debugPrint("‼️ STEP 6 FAILED (supabase): $e");
      debugPrint("$st");
    }

    // 7️⃣ SAATWA — Hive
    try {
      await HiveService.init();
      debugPrint("STEP 7: HiveService done");
    } catch (e, st) {
      debugPrint("‼️ STEP 7 FAILED (hive): $e");
      debugPrint("$st");
    }

    // 8️⃣ AATHWA — Audio Service
    try {
      audioHandler = await AudioService.init(
        builder: () => QuranAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'quran_audio',
          androidNotificationChannelName: 'Quran Playback',
          androidNotificationOngoing: true,
          androidNotificationIcon: 'mipmap/ic_launcher',
          androidShowNotificationBadge: true,
          notificationColor: Color(0xff5BC0BE),
        ),
      );
      debugPrint("STEP 8: AudioService done");
    } catch (e, st) {
      debugPrint("‼️ STEP 8 FAILED (audio_service): $e");
      debugPrint("$st");
    }

    // 9️⃣ AAKHIR MEIN — App run karo
    debugPrint("STEP 9: calling runApp() now");
    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(),
      ),
    );
    debugPrint("STEP 10: runApp() called successfully ✅");

  }, (error, stackTrace) {
    debugPrint("🔥 UNCAUGHT ERROR: $error");
    debugPrint("$stackTrace");
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  void _handleIncomingLinks() {
    // Jab app band ho aur link se khule
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _navigateToItem(uri);
      }
    });

    // Jab app pehle se khuli ho aur link aaye
    _appLinks.uriLinkStream.listen((uri) {
      _navigateToItem(uri);
    });
  }

  void _navigateToItem(Uri uri) {
    final itemId = uri.queryParameters['id'];
    if (itemId != null) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => AllDuaScreen()),
      );
    }
  }

  bool haspermission = false;
  ThemeMode get themeMode => _themeMode;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  Future getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        haspermission = true;
      } else {
        Permission.location.request().then((value) {
          setState(() {
            haspermission = (value == PermissionStatus.granted);
          });
        });
      }
    }
  }

  Future<bool> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isFirstTime") ?? true;
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
      ),
      home: SplashScreen(),
    );
  }
}