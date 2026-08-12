import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class PrayerAzanService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'prayer_azan_channel';
  static const String _channelName = 'Prayer Azan';

  static const Map<String, int> prayerNotificationIds = {
    'Fajr': 20,
    'Dhuhr': 21,
    'Asr': 22,
    'Maghrib': 23,
    'Isha': 24,
  };

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
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
  );

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

    // ✅ Purana channel delete karo, naya sound ke sath banao
    await _recreateChannel();
    await _requestPermissions();
    debugPrint("✅ PrayerAzanService initialized");
  }

  // ✅ Channel delete + recreate — har app start pe fresh channel
  static Future<void> _recreateChannel() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) return;

    // Purana channel delete karo
    await android.deleteNotificationChannel(channelId: _channelId);
    debugPrint('🗑️ Old channel deleted');

    // Naya channel banao sound ke sath
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('adhan'),
      playSound: true,
      enableVibration: false,
    );
    await android.createNotificationChannel(channel);
    debugPrint('✅ New channel created with adhan sound');
  }

  static Future<void> _requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    final exactAlarm = await android?.canScheduleExactNotifications();
    final notifPerm = await android?.areNotificationsEnabled();
    debugPrint('🔔 Exact alarm allowed: $exactAlarm');
    debugPrint('🔔 Notifications enabled: $notifPerm');
  }

  // ── Switch ON — azan schedule karo (daily repeat) ─────────────
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
    
    if (prayerTime.isBefore(now)) {
      prayerTime = prayerTime.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: id,
      title: "$prayerName Prayer Time 🕌",
      body: "It's time for $prayerName",
      scheduledDate: tz.TZDateTime.from(
        prayerTime, 
        tz.local,
        
        ),
      notificationDetails: _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint("✅ Azan scheduled: $prayerName at $prayerTime");
  }
// Future<void> testNotification() async {
//   final now = tz.TZDateTime.now(tz.local);
//   final testTime = now.add(const Duration(seconds: 10));

//   debugPrint("🧪 NOW: $now");
//   debugPrint("🧪 TEST TIME: $testTime");

//   await _plugin.zonedSchedule(
//     id: 999,
//     title: "Test Azan 🕌",
//     body: "10 seconds test notification",
//     scheduledDate: testTime,
//     notificationDetails: _notificationDetails,
//     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//   );

//   debugPrint("✅ TEST notification scheduled");
// }
  // ── TEST — 5 seconds mein fire karo (one-time) ────────────────
  // Future<void> testAzan(String prayerName) async {
  //   final id = prayerNotificationIds[prayerName];
  //   if (id == null) {
  //     debugPrint("❌ Unknown prayer: $prayerName");
  //     return;
  //   }

  //   final testTime =
  //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

  //   await _plugin.zonedSchedule(
  //     id: id,
  //     title: "$prayerName Prayer Time 🕌 (Test)",
  //     body: "Test: It's time for $prayerName",
  //     scheduledDate: testTime,
  //     notificationDetails: _notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     // matchDateTimeComponents nahi — one-time fire
  //   );

  //   debugPrint("✅ TEST azan scheduled: $prayerName at $testTime");
  // }

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