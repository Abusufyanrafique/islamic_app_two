import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:timezone/timezone.dart' as tz;

import 'package:timezone/data/latest.dart' as tz;




class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    //  Timezone sahi set karo
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    try{
      final AndroidFlutterLocalNotificationsPlugin? androidImpl =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();

      final IOSFlutterLocalNotificationsPlugin? iosImpl =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      await iosImpl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }catch (e) {
      print("Permission error: $e");
    }

  }

  Future<void> scheduleNotificationAtTime({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    //  Debug ke liye print
    print('🕐 Abhi: $now');
    print('⏰ Scheduled: $scheduledDate');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Channel',
          channelDescription: 'Scheduled notifications channel',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print('✅ scheduleNotificationAtTime done!');
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // ✅ Debug ke liye print
    print('🕐 Abhi: $now');
    print('⏰ Daily Scheduled: $scheduledDate');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Channel',
          channelDescription: 'Daily notifications channel',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print('✅ scheduleDailyNotification done!');
  }

  Future<void> showNotification(int id, String title, String body) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.now(tz.local).add(
        const Duration(seconds: 1),
      ),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: 'Main notification channel',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}







//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
//
//   static Future<void> init() async {
//     const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
//
//     // FIX: You MUST use the named parameter 'settings'
//     await _notifications.initialize(
//       settings: const InitializationSettings(
//         android: androidInit,
//         iOS: iosInit,
//       ),
//     );
//   }
//
//   static Future<void> scheduleAlarm({
//     required int id,
//     required String title,
//     required DateTime scheduledTime,
//   }) async {
//     await _notifications.zonedSchedule(
//       id: id,
//       title: title,
//       body: 'Your alarm is ringing!',
//       scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
//       notificationDetails: const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'alarm_id',
//           'Alarms',
//           importance: Importance.max,
//           priority: Priority.high,
//           fullScreenIntent: true,
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//       // FIX: In v21.0.0, 'uiLocalNotificationDateInterpretation' is REMOVED.
//       // You only need 'androidScheduleMode'.
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }
// }
//
//
// class AlarmScreen extends StatefulWidget {
//   const AlarmScreen({super.key});
//
//   @override
//   State<AlarmScreen> createState() => _AlarmScreenState();
// }
//
// class _AlarmScreenState extends State<AlarmScreen> {
//   TimeOfDay _selectedTime = TimeOfDay.now();
//
//   Future<void> _pickTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//     );
//     if (picked != null) {
//       setState(() => _selectedTime = picked);
//     }
//   }
//
//   void _setAlarm() {
//     final now = DateTime.now();
//     DateTime scheduleDate = DateTime(
//       now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute,
//     );
//
//     // If the time has already passed today, schedule for tomorrow
//     if (scheduleDate.isBefore(now)) {
//       scheduleDate = scheduleDate.add(const Duration(days: 1));
//     }
// // Inside your Alarm Screen button:
//     NotificationService.scheduleAlarm(
//       id: 1,
//       title: "Wake Up",
//       scheduledTime: DateTime.now().add(const Duration(seconds: 10)),
//     );
//    // NotificationService.scheduleAlarm(0, "Wake Up!", scheduleDate);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Alarm set for ${_selectedTime.format(context)}")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Set Alarm")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.alarm, size: 80, color: Colors.blue),
//             const SizedBox(height: 20),
//             Text(
//               _selectedTime.format(context),
//               style: Theme.of(context).textTheme.displayLarge,
//             ),
//             ElevatedButton(
//               onPressed: _pickTime,
//               child: const Text("Pick Time"),
//             ),
//             const SizedBox(height: 40),
//             FilledButton.icon(
//               onPressed: _setAlarm,
//               icon: const Icon(Icons.check),
//               label: const Text("Schedule Notification"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }