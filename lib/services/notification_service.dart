import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService1 {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

 Future<void> initNotification() async {
  const androidInit = AndroidInitializationSettings('mosque_icon');
  const iosInit = DarwinInitializationSettings();
final initialized = await _plugin.initialize(
  settings: const InitializationSettings(android: androidInit, iOS: iosInit),
  onDidReceiveNotificationResponse: (details) {},
);
  debugPrint("Plugin initialized: $initialized");
  await _requestPermissions();
  await scheduleDailyPrayerNotifications();
}

  Future<void> _requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  Future<void> scheduleDailyPrayerNotifications() async {
    debugPrint("scheduleDailyPrayerNotifications called");

    final coords = Coordinates(33.6007, 73.0679);
    final params = CalculationMethodParameters.ummAlQura();
    final prayerTimes = PrayerTimes(
      coordinates: coords,
      date: DateTime.now(),
      calculationParameters: params,
    );

    final now = DateTime.now();

    // ── Sehri — Fajr se 30 min pehle ──────────────────────────
    var sehriTime = prayerTimes.fajr!.toLocal().subtract(const Duration(minutes: 30));
    if (sehriTime.isBefore(now)) sehriTime = sehriTime.add(const Duration(days: 1));

    // ── Raat — Isha ke 1 ghante baad ──────────────────────────
    var raatTime = prayerTimes.isha!.toLocal().add(const Duration(hours: 1));
    if (raatTime.isBefore(now)) raatTime = raatTime.add(const Duration(days: 1));

    // ── Sehri Notification ─────────────────────────────────────
    await _plugin.zonedSchedule(
      id: 10,
      title: "📖 Time for Quran Recitation",
      body: "Start your morning with the words of Allah.",
      scheduledDate: tz.TZDateTime.from(
        sehriTime,
         tz.local,
         ),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_reminder_channel',
          'Prayer Reminders',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'mosque_icon',
          largeIcon: DrawableResourceAndroidBitmap('mosque_icon'),
          color: Color(0xFF00B894),
         styleInformation: BigTextStyleInformation(
            "🌅 <b>Begin your day with Quran</b>\n\n"
            "• Open the Quran and recite with reflection\n"
            "• Even a few verses bring immense reward\n"
            "• The best of you are those who learn the Quran and teach it\n"
            "• May Allah bless your morning with His words",
            htmlFormatBigText: true,
            contentTitle: "<b>📖 Quran Recitation Time</b>",
            htmlFormatContentTitle: true,
            summaryText: "<i>Tap to open app</i>",
            htmlFormatSummaryText: true,
          ),
          visibility: NotificationVisibility.public,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // ── Raat Notification ──────────────────────────────────────
    await _plugin.zonedSchedule(
      id: 11,
      title: "🌙 Night Prayer Time!",
      body: "It's time for Tahajjud and dua.",
      scheduledDate: tz.TZDateTime.from(raatTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_reminder_channel',
          'Prayer Reminders',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'mosque_icon',
          largeIcon: DrawableResourceAndroidBitmap('mosque_icon'),
          color: Color(0xFF6C5CE7),
          styleInformation: BigTextStyleInformation(
            "🌟 <b>Time for Tahajjud & Dua</b>\n\n"
            "• Wake up for Tahajjud now\n"
            "• Perform Wudu\n"
            "• Make your Niyyat for Tahajjud\n"
            "• Don't forget to make Dua",
            htmlFormatBigText: true,
            contentTitle: "<b>🌙 Night Prayer Time!</b>",
            htmlFormatContentTitle: true,
            summaryText: "<i>Tap to open app</i>",
            htmlFormatSummaryText: true,
          ),
          visibility: NotificationVisibility.public,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // ═══════════════════════════════════════════════════════════
    // ⚠️ COMMENTED OUT — Duplicate azan notification hata di gayi.
    // Azan (Fajr/Dhuhr/Asr/Maghrib/Isha) ab sirf PrayerAzanService
    // handle karega. Ye wala block user ko dohri notification bhej
    // raha tha kyunke dono services same 5 prayers alag channel
    // ('prayer_azan_channel_v3') pe schedule kar rahe the.
    // ═══════════════════════════════════════════════════════════

    // final prayers = {
    //   'Fajr':    prayerTimes.fajr!.toLocal(),
    //   'Dhuhr':   prayerTimes.dhuhr!.toLocal(),
    //   'Asr':     prayerTimes.asr!.toLocal(),
    //   'Maghrib': prayerTimes.maghrib!.toLocal(),
    //   'Isha':    prayerTimes.isha!.toLocal(),
    // };
    //
    // int id = 20;
    // for (final entry in prayers.entries) {
    //   var prayerTime = entry.value;
    //   if (prayerTime.isBefore(now)) {
    //     prayerTime = prayerTime.add(const Duration(days: 1));
    //   }
    //
    //   await _plugin.zonedSchedule(
    //     id: id++,
    //     title: "${entry.key} Prayer Time 🕌",
    //     body: "It's time for ${entry.key}",
    //     scheduledDate: tz.TZDateTime.from(prayerTime, tz.local),
    //     notificationDetails: const NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         'prayer_azan_channel_v3',
    //         'Prayer Azan',
    //         importance: Importance.max,
    //         priority: Priority.high,
    //         icon: 'mosque_icon',
    //         largeIcon: DrawableResourceAndroidBitmap('mosque_icon'),
    //         playSound: true,
    //         enableVibration: true,
    //         visibility: NotificationVisibility.public,
    //         fullScreenIntent: true,
    //       ),
    //     ),
    //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //     matchDateTimeComponents: DateTimeComponents.time,
    //   );
    //
    //   debugPrint(" ${entry.key} scheduled: $prayerTime");
    // }

    debugPrint("✅ Sehri: $sehriTime");
    debugPrint("✅ Raat: $raatTime");
  }
}