import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification/View/Prayer/PrayersTimeScreen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:audioplayers/audioplayers.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

class PrayerTimeScreen1 extends StatefulWidget {
  const PrayerTimeScreen1({super.key});

  @override
  State<PrayerTimeScreen1> createState() => _PrayerTimeScreen1State();
}

class _PrayerTimeScreen1State extends State<PrayerTimeScreen1> {
  static const Color lightTealBorder = Color(0xFFBFE7E4);

  double _latitude = 21.3891;
  double _longitude = 39.8579;
  String _locationName = 'Fetching location...';
  bool _locationLoaded = false;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _azanPlaying = false;

  final Set<String> _stoppedPrayers = {};

  int selectedDayIndex = 0;
  late DateTime selectedDate;
  late List<DateTime> weekDates;

  late PrayerTimes _prayerTimes;
  List<PrayerItem> prayers = [];

  Timer? _timer;
  Timer? _azanCheckTimer;

  String currentPrayerName = "";
  String currentPrayerTime = "";
  String nextPrayerName = "";
  String nextPrayerTime = "";
  String countdownText = "";
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
    _initNotifications();

    selectedDate = DateTime.now();
    weekDates = List.generate(5, (i) => DateTime.now().add(Duration(days: i)));

    _initPrayerItems();
    _fetchLocationThenLoad();
  }

  void _initPrayerItems() {
    prayers = [
      PrayerItem(name: "Fajr",    icon: AllImages.fajar,       notificationOn: true),
      PrayerItem(name: "Dhuhr",   icon: AllImages.dhuhr,       notificationOn: true),
      PrayerItem(name: "Asr",     icon: AllImages.asr,         notificationOn: true),
      PrayerItem(name: "Maghrib", icon: AllImages.maghribicon, notificationOn: true),
      PrayerItem(name: "Isha",    icon: AllImages.ishaicon,    notificationOn: true),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    _azanCheckTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ── GPS Location ───────────────────────────────────────────────────────────

  Future<void> _fetchLocationThenLoad() async {
    final service = SalatTimeService();
    final position = await service.getCurrentLocation();

    if (position != null) {
      _latitude  = position.latitude;
      _longitude = position.longitude;
      final result = await service.fetchPrayerTimes();
      _locationName = result.locationName;
    } else {
      _locationName = 'Makkah, Saudi Arabia';
    }

    _calculatePrayerTimes();
    _updateCountdown();

    setState(() => _locationLoaded = true);
    await _scheduleAllOnNotifications();
    _startTimers();
  }

  // ── Timers ─────────────────────────────────────────────────────────────────

  void _startTimers() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );

    _azanCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkAndPlayAzan(),
    );
  }

  // ── Prayer Time Calculation ────────────────────────────────────────────────

  void _calculatePrayerTimes() {
    _stoppedPrayers.clear();

    final coords = Coordinates(_latitude, _longitude);
    final params = CalculationMethodParameters.ummAlQura();

    _prayerTimes = PrayerTimes(
      coordinates: coords,
      date: selectedDate,
      calculationParameters: params,
    );

    final times = <String, DateTime>{
      "Fajr":    _prayerTimes.fajr!.toLocal(),
      "Dhuhr":   _prayerTimes.dhuhr!.toLocal(),
      "Asr":     _prayerTimes.asr!.toLocal(),
      "Maghrib": _prayerTimes.maghrib!.toLocal(),
      "Isha":    _prayerTimes.isha!.toLocal(),
    };

    for (final prayer in prayers) {
      final dt = times[prayer.name]!;
      prayer.time     = _formatTime(dt);
      prayer.dateTime = dt;
    }
  }

  String _formatTime(DateTime dt) =>
      DateFormat('hh:mm a').format(dt).replaceAll(' ', '').toLowerCase();

  // ── Countdown ──────────────────────────────────────────────────────────────

  void _updateCountdown() {
    if (prayers.isEmpty || prayers.any((p) => p.dateTime == null)) return;

    final now          = DateTime.now();
    final orderedTimes = prayers.map((p) => p.dateTime!).toList();

    int nextIndex = orderedTimes.indexWhere((t) => t.isAfter(now));
    int currentIndex;
    DateTime nextTime, currentTime;

    if (nextIndex == -1) {
      currentIndex = prayers.length - 1;
      nextIndex    = 0;
      nextTime     = orderedTimes[0].add(const Duration(days: 1));
      currentTime  = orderedTimes[currentIndex];
    } else if (nextIndex == 0) {
      currentIndex = prayers.length - 1;
      nextTime     = orderedTimes[0];
      currentTime  = orderedTimes[currentIndex].subtract(const Duration(days: 1));
    } else {
      currentIndex = nextIndex - 1;
      nextTime     = orderedTimes[nextIndex];
      currentTime  = orderedTimes[currentIndex];
    }

    final remaining = nextTime.difference(now);
    final hours     = remaining.inHours;
    final minutes   = remaining.inMinutes % 60;
    final total     = nextTime.difference(currentTime).inSeconds;
    final elapsed   = now.difference(currentTime).inSeconds;
    final progress  = total > 0 ? (elapsed / total).clamp(0.0, 1.0) : 0.0;

    if (mounted) {
      setState(() {
        currentPrayerName = prayers[currentIndex].name;
        currentPrayerTime = prayers[currentIndex].time;
        nextPrayerName    = prayers[nextIndex].name;
        nextPrayerTime    = prayers[nextIndex].time;
        countdownText     = "${hours}h ${minutes}m left";
        progressValue     = progress;
      });
    }
  }

  // ── In-App Azan ────────────────────────────────────────────────────────────

  void _checkAndPlayAzan() {
    if (_azanPlaying) return;
    final now = DateTime.now();

    for (final prayer in prayers) {
      if (prayer.dateTime == null) continue;
      if (_stoppedPrayers.contains(prayer.name)) continue;

      final diff = now.difference(prayer.dateTime!).inSeconds.abs();
      if (diff <= 30) {
        _playAzan();
        break;
      }
    }
  }

  Future<void> _playAzan() async {
    if (_azanPlaying) return;
    if (mounted) setState(() => _azanPlaying = true);

    await _audioPlayer.play(AssetSource('ringtone/adhan.mp3'));

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _azanPlaying = false);
    });
  }

  Future<void> _stopAzan() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _azanPlaying = false;
        if (currentPrayerName.isNotEmpty) {
          _stoppedPrayers.add(currentPrayerName);
        }
      });
    }
  }

  // ── Notifications ──────────────────────────────────────────────────────────

  Future<void> _initNotifications() async {
    const androidInit = AndroidInitializationSettings('mosque_icon');
    const iosInit     = DarwinInitializationSettings();
    await _notificationsPlugin.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
    );
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    final ios = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _scheduleAllOnNotifications() async {
    for (int i = 0; i < prayers.length; i++) {
      if (prayers[i].notificationOn) {
        await _scheduleNotification(prayers[i], i);
      }
    }
  }

  Future<void> _scheduleNotification(PrayerItem prayer, int id) async {
    if (prayer.dateTime == null) return;

    var scheduleTime = prayer.dateTime!;
    if (scheduleTime.isBefore(DateTime.now())) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'prayer_azan_channel',
      'Prayer Azan',
      channelDescription: 'Plays azan sound at prayer time',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'mosque_icon',
      largeIcon: DrawableResourceAndroidBitmap('mosque_icon'),
      sound: RawResourceAndroidNotificationSound('adhan'),
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adhan.mp3',
    );

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: "${prayer.name} Prayer Time 🕌",
      body: "It's time for ${prayer.name} — ${prayer.time}",
      scheduledDate: tz.TZDateTime.from(scheduleTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _toggleNotification(PrayerItem prayer, int id) async {
    final turningOn = !prayer.notificationOn;
    setState(() => prayer.notificationOn = turningOn);

    if (turningOn) {
      await _scheduleNotification(prayer, id);
    } else {
      await _notificationsPlugin.cancel(id: id);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getHeight(10)),
              _buildTopBar(context),
              SizedBox(height: getHeight(20)),
              _buildLocationWeatherRow(),
              SizedBox(height: getHeight(8)),
              Text(
                DateFormat('MMMM d, yyyy').format(selectedDate),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: getHeight(20)),
              _buildDateSelector(),
              SizedBox(height: getHeight(20)),
              if (!_locationLoaded)
                 Center(
                  child: SpinKitFadingCircle(
                  color: AppColors.labbaik,
                  // size: 50.0,
                   ),
                  )
              else ...[
                _buildCurrentPrayerCard(),
                SizedBox(height: getHeight(20)),
                ...prayers.asMap().entries.map(
                  (e) => _buildPrayerTile(e.value, e.key),
                ),
              ],
              if (_azanPlaying)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getHeight(16),
                    ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _stopAzan,
                      icon: const Icon(
                        Icons.stop_circle_outlined,
                        ),
                      label: const Text('Stop Azan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: getHeight(14)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: getHeight(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back, 
            size: 24, 
            color: Colors.black,
            ),
        ),
        Expanded(
          child: Center(
            child: Text(
              AllText.prayerTime,
              style: AppColors().customTextStyle18().copyWith(
                    fontSize: getFont(26),
                  ),
            ),
          ),
        ),
        SizedBox(width: getWidth(24)),
      ],
    );
  }

  Widget _buildLocationWeatherRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              _locationLoaded ? Icons.location_on : Icons.location_searching,
              size: 14,
              color: AppColors.labbaik,
            ),
            SizedBox(width: getWidth(4)),
            Text(_locationName, style: AppColors().customTextStyle14()),
          ],
        ),
        Row(
          children: const [
            Icon(Icons.wb_sunny, size: 16, color: Colors.orange),
            SizedBox(width: 4),
            Text("35°C", style: TextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: getHeight(70),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: weekDates.length,
        separatorBuilder: (_, __) => SizedBox(width: getWidth(10)),
        itemBuilder: (context, index) {
          final isSelected = index == selectedDayIndex;
          final date = weekDates[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDayIndex = index;
                selectedDate = date;
              });
              _calculatePrayerTimes();
              _updateCountdown();
            },
            child: Container(
              height: getHeight(81),
              width: getWidth(65),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.labbaik : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.labbaik : lightTealBorder,
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.labbaik,
                    ),
                  ),
                  SizedBox(height: getHeight(4)),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.labbaik,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentPrayerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.labbaik,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentPrayerName.isEmpty ? '...' : currentPrayerName,
                    style: AppColors().customTextStyle18().copyWith(color: AppColors.white),
                  ),
                  SizedBox(height: getHeight(4)),
                  Text(
                    currentPrayerTime.isEmpty ? '--:--' : currentPrayerTime,
                    style: AppColors().customTextStyle14().copyWith(
                          color: AppColors.white, fontSize: getFont(18)),
                  ),
                ],
              ),
              Text(
                countdownText.isEmpty ? '...' : countdownText,
                style: AppColors().customTextStyle14().copyWith(
                      color: AppColors.white, fontSize: getFont(18)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Next",
                      style: AppColors().customTextStyle12().copyWith(
                            color: AppColors.white, fontSize: getFont(16))),
                  SizedBox(height: getHeight(9)),
                  Text(
                    nextPrayerName.isEmpty ? '...' : nextPrayerName,
                    style: AppColors().customTextStyle20().copyWith(color: AppColors.white),
                  ),
                  SizedBox(height: getHeight(9)),
                  Text(
                    nextPrayerTime.isEmpty ? '--:--' : nextPrayerTime,
                    style: AppColors().customTextStyle14().copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: getHeight(15)),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTile(PrayerItem prayer, int id) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(16),
        vertical: getHeight(14),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lightTealBorder, width: 1.2),
      ),
      child: Row(
        children: [
          SvgPicture.asset(prayer.icon, width: getWidth(24), height: getHeight(24)),
          SizedBox(width: getWidth(14)),
          Expanded(child: Text(prayer.name, style: AppColors().customTextStyle18())),
          Text(
            prayer.time,
            style: AppColors().customTextStyleBold16().copyWith(fontSize: getFont(14)),
          ),
          SizedBox(width: getWidth(14)),
          PrayerBellIcon(
            notificationOn: prayer.notificationOn,
            isMuted: prayer.isMuted,
            onTap: () => _toggleNotification(prayer, id),
          ),
        ],
      ),
    );
  }
}

// ── Data Model ────────────────────────────────────────────────────────────────

class PrayerItem {
  final String name;
  final String icon;
  bool notificationOn;
  bool isMuted;
  String time;
  DateTime? dateTime;

  PrayerItem({
    required this.name,
    required this.icon,
    required this.notificationOn,
    this.isMuted = false,
    this.time = "",
    this.dateTime,
  });
}

// ── Bell Icon Widget ──────────────────────────────────────────────────────────

class PrayerBellIcon extends StatelessWidget {
  final bool notificationOn;
  final bool isMuted;
  final VoidCallback? onTap;

  const PrayerBellIcon({
    super.key,
    required this.notificationOn,
    this.isMuted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isMuted
        ? AppColors.bellcolor
        : (notificationOn ? Colors.black : Colors.black45);

    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        AllImages.bell,
        width: getWidth(20),
        height: getHeight(20),
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );
  }
}