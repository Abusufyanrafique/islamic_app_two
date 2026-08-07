// import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart'; 
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;

// class NotificationService {
//   static final NotificationService _notificationService =
//   NotificationService._internal();

//   factory NotificationService() {
//     return _notificationService;
//   }

//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     tz.initializeTimeZones();
//     final String timeZoneName = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZoneName));

//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );

//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       settings: initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {},
//     );

//     await _requestPermissions();
//   }
//   Future<void> _requestPermissions() async {
//     try {
//       if (Platform.isAndroid) {
//         final androidImpl = flutterLocalNotificationsPlugin
//             .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

//         // Ye check karein ke kya androidImpl null to nahi
//         if (androidImpl != null) {
//           await androidImpl.requestNotificationsPermission();
//         }
//       } else if (Platform.isIOS) {
//         final iosImpl = flutterLocalNotificationsPlugin
//             .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

//         await iosImpl?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//       }
//     } catch (e) {
//       print("Permission error: $e");
//     }
//   }
//   // Future<void> _requestPermissions() async {
//   //   try{
//   //     final AndroidFlutterLocalNotificationsPlugin? androidImpl =
//   //     flutterLocalNotificationsPlugin
//   //         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//   //     await androidImpl?.requestNotificationsPermission();
//   //
//   //     final IOSFlutterLocalNotificationsPlugin? iosImpl =
//   //     flutterLocalNotificationsPlugin
//   //         .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
//   //     await iosImpl?.requestPermissions(
//   //       alert: true,
//   //       badge: true,
//   //       sound: true,
//   //     );
//   //   }catch (e) {
//   //     print("Permission error: $e");
//   //   }
//   //
//   // }

//   Future<void> scheduleNotificationAtTime({
//     required int id,
//     required String title,
//     required String body,
//     required int hour,
//     required int minute,
//   }) async
//   {
//     final now = tz.TZDateTime.now(tz.local);

//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minute,
//     );

//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }

//     // ✅ Debug ke liye print
//     print('🕐 Abhi: $now');
//     print('⏰ Scheduled: $scheduledDate');
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id: id,
//       title: title,
//       body: body,
//       scheduledDate: scheduledDate,
//       notificationDetails: const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'adhan_channel', // 👈 change this (important)
//           'Adhan Channel',
//           channelDescription: 'Adhan notifications',
//           importance: Importance.max,
//           priority: Priority.max,
//           playSound: true,
//           sound: RawResourceAndroidNotificationSound('adhan'),
//         ),
//         iOS: DarwinNotificationDetails(
//           sound: 'adhan.mp3',

//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       matchDateTimeComponents: DateTimeComponents.time,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );

//     // await flutterLocalNotificationsPlugin.zonedSchedule(
//     //   id: id,
//     //   title: title,
//     //   body: body,
//     //   scheduledDate: scheduledDate,
//     //   notificationDetails: const NotificationDetails(
//     //     android: AndroidNotificationDetails(
//     //       'scheduled_channel',
//     //       'Scheduled Channel',
//     //       channelDescription: 'Scheduled notifications channel',
//     //       importance: Importance.max,
//     //       priority: Priority.max,
//     //     ),
//     //     iOS: DarwinNotificationDetails(
//     //       sound: 'default',
//     //       presentAlert: true,
//     //       presentBadge: true,
//     //       presentSound: true,
//     //     ),
//     //   ),
//     //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     // );

//     print('✅ scheduleNotificationAtTime done!');
//   }

//   Future<void> scheduleDailyNotification({
//     required int id,
//     required String title,
//     required String body,
//     required int hour,
//     required int minute,
//   }) async
//   {
//     final now = tz.TZDateTime.now(tz.local);

//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minute,
//     );

//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }

//     // ✅ Debug ke liye print
//     print('🕐 Abhi: $now');
//     print('⏰ Daily Scheduled: $scheduledDate');

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id: id,
//       title: title,
//       body: body,
//       scheduledDate: scheduledDate,
//       notificationDetails: const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_channel',
//           'Daily Channel',
//           channelDescription: 'Daily notifications channel',
//           importance: Importance.max,
//           priority: Priority.max,
//         ),
//         iOS: DarwinNotificationDetails(
//           sound: 'default',
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       matchDateTimeComponents: DateTimeComponents.time,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );

//     print('✅ scheduleDailyNotification done!');
//   }

//   Future<void> showNotification(int id, String title, String body) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id: id,
//       title: title,
//       body: body,
//       scheduledDate: tz.TZDateTime.now(tz.local).add(
//         const Duration(seconds: 1),
//       ),
//       notificationDetails: const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'main_channel',
//           'Main Channel',
//           channelDescription: 'Main notification channel',
//           importance: Importance.max,
//           priority: Priority.max,
//         ),
//         iOS: DarwinNotificationDetails(
//           sound: 'default',
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }
// }