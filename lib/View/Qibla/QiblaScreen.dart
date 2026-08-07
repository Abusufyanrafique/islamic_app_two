import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:local_notification/hajj_and_Umrah_guide/hajj_umrah_splash_screen.dart';
import '../../Model/PrayerCacheModel.dart';
import '../../Utils/Constants/userFeedback.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';


class QiblaState {
  final double compassHeading;
  final double qiblaDirection;
  final bool isLoading;
  final bool isFromCache;
  final String errorMsg;

  QiblaState({
    this.compassHeading = 0.0,
    this.qiblaDirection = 0.0,
    this.isLoading = true,
    this.isFromCache = false,
    this.errorMsg = '',
  });

  QiblaState copyWith({
    double? compassHeading,
    double? qiblaDirection,
    bool? isLoading,
    bool? isFromCache,
    String? errorMsg,
  }) {
    return QiblaState(
      compassHeading: compassHeading ?? this.compassHeading,
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      isLoading: isLoading ?? this.isLoading,
      isFromCache: isFromCache ?? this.isFromCache,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}

class QiblaCubit extends Cubit<QiblaState> {
  final HiveService _hive = HiveService();
  StreamSubscription? _compassSubscription;

  // Tracks whether device was already aligned with Qibla on the
  // previous compass reading, so we only fire feedback once per
  // "entering the aligned zone" event (not on every frame).
  bool _wasAligned = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  QiblaCubit() : super(QiblaState()) {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _testSoundOnStartup();
  }

  // TEMPORARY: fires once on app start to confirm the sound asset
  // itself works, independent of compass/alignment logic.
  // Remove this after confirming sound works correctly.
  void _testSoundOnStartup() async {
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('🧪 Testing startup sound...');
    await _playBeep();
  }

  Future<void> _playBeep() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('ringtone/beep.wav'), volume: 1.0);
      debugPrint('✅ beep.wav play() called successfully');
    } catch (e) {
      debugPrint('❌ Sound failed: $e');
    }
  }

  // Public wrapper so a UI button can trigger a sound test on demand,
  // removing any timing dependency on app startup.
  void debugTestSound() {
    debugPrint('🧪 Manual test button pressed');
    _playBeep();
  }

  void init() async {
    // 1. Check Cache
    final saved = _hive.loadSavedLocation();
    if (saved != null) {
      final qibla = _calculateQibla(saved['lat']!, saved['lng']!);
      emit(state.copyWith(
        qiblaDirection: qibla,
        isFromCache: true,
        isLoading: false,
      ));
      _startCompass();
      _updateLocationInBackground();
    } else {
      fetchLocationFromGPS();
    }
  }

  Future<void> fetchLocationFromGPS() async {
    emit(state.copyWith(isLoading: true, errorMsg: ''));
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) {
        emit(state.copyWith(isLoading: false, errorMsg: 'Location permission denied.'));
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      await _hive.saveLocation(pos.latitude, pos.longitude);

      final qibla = _calculateQibla(pos.latitude, pos.longitude);
      emit(state.copyWith(qiblaDirection: qibla, isLoading: false, isFromCache: false));
      _startCompass();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMsg: 'Location not found. Turn on GPS.'));
    }
  }

 void _updateLocationInBackground() async {
  try {
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(const Duration(seconds: 10));
    await _hive.saveLocation(pos.latitude, pos.longitude);
    final qibla = _calculateQibla(pos.latitude, pos.longitude);
    emit(state.copyWith(qiblaDirection: qibla, isFromCache: false));
  } catch (e) {
    debugPrint('Background update failed: $e');
    emit(state.copyWith(isFromCache: false)); 
  }
}

  void _startCompass() {
    _compassSubscription?.cancel();
    _wasAligned = false;

    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        final heading = event.heading!;
        emit(state.copyWith(compassHeading: heading));
        _checkAlignmentFeedback(heading);
      }
    });
  }


  void _checkAlignmentFeedback(double heading) {
    final angle = (state.qiblaDirection - heading + 360) % 360;
    final isAligned = angle < 5 || angle > 355;

    // Temporary debug line — remove once sound is confirmed working.
    debugPrint('Qibla check → angle: ${angle.toStringAsFixed(1)}, isAligned: $isAligned, wasAligned: $_wasAligned');

    if (isAligned && !_wasAligned) {
      debugPrint('🔔 Alignment triggered — attempting haptic + sound');
      HapticFeedback.mediumImpact();
      _playBeep();
    }
    _wasAligned = isAligned;
  }

  double _calculateQibla(double lat, double lng) {
    const double kLat = 21.4225;
    const double kLng = 39.8262;
    final lat1 = lat * math.pi / 180;
    final lat2 = kLat * math.pi / 180;
    final dLng = (kLng - lng) * math.pi / 180;
    final y = math.sin(dLng) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    final bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360;
  }

  @override
  Future<void> close() {
    _compassSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QiblaCubit()..init(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F0),
        body: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _BgPatternPainter())),
            BlocBuilder<QiblaCubit, QiblaState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                      MaterialPageRoute(
                     builder: (_) => const HajjUmrahSplashScreen(),
        ),
      );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(height: 10,),
                      _buildKaabaImage(),
                      SizedBox(height: 10,),
                      if (state.isFromCache && !state.isLoading) _buildCacheBadge(),
                      // TEMPORARY debug button — remove once sound is confirmed working.
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8),
                      //   child: ElevatedButton(
                      //     onPressed: () => context.read<QiblaCubit>().debugTestSound(),
                      //     child: const Text('🔊 Test Sound (tap me)'),
                      //   ),
                      // ),
                      if (state.isLoading)
                         Expanded(child: Center(child: spinkit)) 
                      else if (state.errorMsg.isNotEmpty)
                        _buildError(context, state.errorMsg)
                      else
                        _buildContent(state),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheBadge() {
    return Container(
      margin:  EdgeInsets.only(top: getHeight(8)),
      padding:  EdgeInsets.symmetric(
        horizontal: getWidth(12), 
        vertical: getHeight(8),
        ),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.shade200
          ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history, 
            size: 14, 
            color: Colors.orange.shade700,
            ),
           SizedBox(width: getWidth(4)),
          Text('Using saved location • Updating...',
              style: TextStyle(
                fontSize: getFont(11),
                color: Colors.orange.shade800,
                )),
        ],
      ),
    );
  }

  Widget _buildContent(QiblaState state) {
    double qiblaAngle = (state.qiblaDirection - state.compassHeading + 360) % 360;

    return SingleChildScrollView(
      child: Column(
        children: [
           SizedBox(height: getHeight(35)),
          _buildCompass(state.compassHeading, state.qiblaDirection),
           SizedBox(height: getHeight(24)),
          _buildDegreeDisplay(qiblaAngle),
           SizedBox(height: getHeight(10)),
          _buildInstruction(qiblaAngle),
           SizedBox(height: getHeight(24)),
        ],
      ),
    );
  }

  // --- UI Helpers (Styles preserved exactly) ---

  Widget _buildCompass(double heading, double qiblaDir) {
    final double ringAngle = -heading * math.pi / 180;
    final double qiblaScreenAngle = (qiblaDir - heading) * math.pi / 180;

    // Determine if currently aligned, to give the Kaaba badge a
    // "locked on" highlight state purely as a visual cue.
    final double diff = (qiblaDir - heading + 360) % 360;
    final bool isAligned = diff < 5 || diff > 355;

    return SizedBox(
      width: getWidth(280),
       height: getHeight(300),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: ringAngle, 
            child: CustomPaint(
              size:  Size(280, 280),
               painter: _RingPainter(),
               )),
          Container(
            width: getWidth(212), 
            height: getHeight(212),
            decoration: BoxDecoration(
              color: Colors.white, shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                   blurRadius: 16, spreadRadius: 2)],
            ),
          ),
          Transform.rotate(
            angle: ringAngle, 
            child: CustomPaint(
              size: const Size(212, 212),
              painter: _NeedlePainter())),
          Container(
            width: getWidth(14), 
            height: getHeight(14), 
            decoration: const BoxDecoration(
              color: Color(0xFF1A4A4A), 
              shape: BoxShape.circle,
              )),
          Transform.rotate(
            angle: qiblaScreenAngle,
            child: SizedBox(
              width: getWidth(212), 
              height: getHeight(212),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 6, 
                    left: 0, 
                    right: 0, 
                    child: Center(
                      child: CustomPaint(
                        size: const Size(16, 14),
                         painter: _ArrowTipPainter()),
                         )),
                  Positioned(
                    top: 18, left: 0, right: 0,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: getWidth(42), 
                        height: getHeight(42),
                        decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle,
                          border: Border.all(
                            color: isAligned
                                ? const Color(0xFF2ECC71)
                                : const Color(0xFFD4A017), 
                            width: 2.5),
                          boxShadow: [BoxShadow(
                            color: (isAligned
                                    ? const Color(0xFF2ECC71)
                                    : const Color(0xFFD4A017))
                                .withOpacity(0.4), 
                            blurRadius: isAligned ? 14 : 10)],
                        ),
                        child:  Center(child: Text(
                          '🕋', 
                        style: TextStyle(fontSize:getFont(20) ))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDegreeDisplay(double angle) {
    return Column(
      children: [
        Text('${angle.toStringAsFixed(0)}°',
            style:  TextStyle(
              fontSize: getFont(58), 
              fontWeight: FontWeight.w900, 
              color: Color(0xFF1A1A1A), 
              letterSpacing: -2)),
         Text("Device's angle to Qibla", 
        style: AppColors().customTextStyleRegular10(
          color:AppColors.black ).copyWith(
            fontSize: getFont(14)
          ),
          ),
      ],
    );
  }

  Widget _buildInstruction(double angle) {
    bool onTarget = angle < 5 || angle > 355;
    String text = onTarget ? 'Congratulations! You are facing the Qibla. ✓'
        : (angle <= 180 ? 'Rotate ${angle.toStringAsFixed(0)}° to the Right' : 'Rotate ${(360 - angle).toStringAsFixed(0)}° to the Left');

    return AnimatedContainer(
      duration:  Duration(milliseconds: 300),
      width: getWidth(300),
      height: getHeight(50),
      margin:  EdgeInsets.symmetric(
        horizontal: getWidth(36),
        ),
      padding:  EdgeInsets.symmetric(
         vertical: getHeight(18),
         ),
      decoration: BoxDecoration(
        color: onTarget
            ? const Color(0xFF2ECC71).withOpacity(0.20)
            : const Color(0xFF56C8C8).withOpacity(0.20),
        borderRadius: BorderRadius.circular(20),
       
      ),
      child: Text(text, textAlign: TextAlign.center,
          style: AppColors().customTextStyleRegular10(
          color:AppColors.black ).copyWith(
            fontSize: getFont(12)
          ),)
    );
  }

  Widget _buildKaabaImage() {
    return ClipRRect(
      borderRadius:  BorderRadius.only(
        bottomLeft: Radius.circular(24), 
        bottomRight: Radius.circular(24)),
      child: SizedBox(
        width: double.infinity, 
        height: getHeight(200),
          child: Image.asset('assets/images/makka.png', 
          fit: BoxFit.cover, errorBuilder: (c, e, s) => 
          const Center(
            child: Text("Error loading image")))),
    );
  }

  Widget _buildError(BuildContext context, String msg) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text('⚠️', style: TextStyle(fontSize: getFont(48))),
             SizedBox(height: getHeight(16)),
            Text(msg, textAlign: TextAlign.center,
             style:  TextStyle(
              fontSize: getFont(16), 
              color: Color(0xFF444444),
              )),
             SizedBox(height: getHeight(24)),
            ElevatedButton(
              onPressed: () => context.read<QiblaCubit>().fetchLocationFromGPS(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5BBCB0),
                 foregroundColor: Colors.white),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
// ── Qibla Angle Calculator ─────────────────────────────────
class QiblaCalculator {
  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  static double calculate(double userLat, double userLng) {
    final lat1 = userLat * math.pi / 180;
    final lat2 = _kaabaLat * math.pi / 180;
    final dLng = (_kaabaLng - userLng) * math.pi / 180;
    final y = math.sin(dLng) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    final bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360;
  }
}


class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const outerR = 140.0;
    const innerR = 112.0;

    canvas.drawCircle(Offset(cx, cy), outerR,
        Paint()..color = const Color(0xFF5BBCB0));
    canvas.drawCircle(Offset(cx, cy), innerR,
        Paint()..color = Colors.white);

    // Gear teeth
    final toothPaint = Paint()..color = const Color(0xFF5BBCB0);
    for (int i = 0; i < 36; i++) {
      final a = i * 2 * math.pi / 36;
      final path = Path()
        ..moveTo(cx + (outerR - 1) * math.cos(a),
            cy + (outerR - 1) * math.sin(a))
        ..lineTo(
            cx + (outerR + 11) * math.cos(a - 0.065),
            cy + (outerR + 11) * math.sin(a - 0.065))
        ..lineTo(
            cx + (outerR + 11) * math.cos(a + 0.065),
            cy + (outerR + 11) * math.sin(a + 0.065))
        ..close();
      canvas.drawPath(path, toothPaint);
    }

    // Tick marks
    final tickPaint = Paint()
      ..color = const Color(0xFF2A6060)
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 72; i++) {
      final a = i * 2 * math.pi / 72;
      final isMajor = i % 9 == 0;
      final r1 = innerR - 2;
      final r2 = r1 - (isMajor ? 11.0 : 5.0);
      canvas.drawLine(
        Offset(cx + r1 * math.cos(a), cy + r1 * math.sin(a)),
        Offset(cx + r2 * math.cos(a), cy + r2 * math.sin(a)),
        tickPaint..strokeWidth = isMajor ? 2.0 : 1.0,
      );
    }

    // N S E W
    final tp = TextPainter(textDirection: TextDirection.ltr);
    final labels = {
      'N': 0.0,
      'E': math.pi / 2,
      'S': math.pi,
      'W': 3 * math.pi / 2
    };
    labels.forEach((lbl, angle) {
      final r = innerR - 20;
      tp.text = TextSpan(
        text: lbl,
        style: TextStyle(
          color: lbl == 'N' ? Colors.red : const Color(0xFF1A4A4A),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(
          cx + r * math.sin(angle) - tp.width / 2,
          cy - r * math.cos(angle) - tp.height / 2,
        ),
      );
    });
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Needle Painter ──────────────────────────────────────────
class _NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas.drawPath(
      Path()
        ..moveTo(cx, cy - 72)
        ..lineTo(cx - 9, cy)
        ..lineTo(cx, cy + 18)
        ..lineTo(cx + 9, cy)
        ..close(),
      Paint()..color = const Color(0xFF1A4A4A),
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx, cy + 72)
        ..lineTo(cx - 9, cy)
        ..lineTo(cx, cy - 18)
        ..lineTo(cx + 9, cy)
        ..close(),
      Paint()..color = const Color(0xFF5BBCB0),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Arrow Tip Painter ───────────────────────────────────────
class _ArrowTipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width / 2, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..close(),
      Paint()..color = const Color(0xFFD4A017),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Background Islamic Pattern ──────────────────────────────
class _BgPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5BBCB0).withOpacity(0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    const sp = 80.0;
    for (double x = 0; x < size.width + sp; x += sp) {
      for (double y = 0; y < size.height + sp; y += sp) {
        canvas.drawCircle(Offset(x, y), 34, paint);
        canvas.drawCircle(Offset(x, y), 20, paint);
        for (int i = 0; i < 8; i++) {
          final a = i * math.pi / 4;
          canvas.drawLine(
            Offset(x + 20 * math.cos(a), y + 20 * math.sin(a)),
            Offset(
                x + 34 * math.cos(a + math.pi / 8),
                y + 34 * math.sin(a + math.pi / 8)),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}