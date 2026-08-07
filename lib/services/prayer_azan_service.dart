import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class PrayerAzanService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ── Har prayer ka fixed notification ID ───────────────────────
  static const Map<String, int> prayerNotificationIds = {
    'Fajr': 20,
    'Dhuhr': 21,
    'Asr': 22,
    'Maghrib': 23,
    'Isha': 24,
  };

  // ── Plugin initialize — app start pe ek baar call karo ────────
  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('mosque_icon');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      ),
      onDidReceiveNotificationResponse: (details) {},
    );
    await _requestPermissions();
    debugPrint("✅ PrayerAzanService initialized");
  }

  static Future<void> _requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  // ── Switch ON — azan schedule karo ───────────────────────────
  // rawTime format: "04:32" (24hr)
  Future<void> scheduleAzan({
    required String prayerName,
    required String rawTime,
  }) async {
    final id = prayerNotificationIds[prayerName];
    if (id == null) {
      debugPrint("❌ Unknown prayer: $prayerName");
      return;
    }

    final parts = rawTime.split(':');
    if (parts.length < 2) {
      debugPrint("❌ Invalid rawTime: $rawTime");
      return;
    }

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = DateTime.now();
    var prayerTime = DateTime(now.year, now.month, now.day, hour, minute);
    // var prayerTime = now.add(const Duration(minutes: 1));
    // Agar time guzar gaya ho to kal ke liye schedule karo
    if (prayerTime.isBefore(now)) {
      prayerTime = prayerTime.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: id,
      title: "$prayerName Prayer Time 🕌",
      body: "It's time for $prayerName",
      scheduledDate: tz.TZDateTime.from(prayerTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_azan_channel_v4', 
          'Prayer Azan',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'mosque_icon',
          largeIcon: DrawableResourceAndroidBitmap('mosque_icon'),
          sound: RawResourceAndroidNotificationSound('adhan'),
          playSound: true,
          enableVibration: false,
          visibility: NotificationVisibility.public,
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, 
    );

    debugPrint("✅ Azan scheduled: $prayerName at $prayerTime");
  }

  // ── Switch OFF — azan cancel karo ────────────────────────────
  Future<void> cancelAzan(String prayerName) async {
    final id = prayerNotificationIds[prayerName];
    if (id == null) return;
    await _plugin.cancel(id: id);
    debugPrint("🔕 Azan cancelled: $prayerName (id=$id)");
  }

  // ── Ek sath sab cancel karo ───────────────────────────────────
  Future<void> cancelAllAzans() async {
    for (final id in prayerNotificationIds.values) {
      await _plugin.cancel(id: id);
    }
    debugPrint("🔕 All azans cancelled");
  }
}