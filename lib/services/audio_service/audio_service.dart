import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();
  final FlutterTts _tts = FlutterTts();
  final ValueNotifier<String?> currentlySpeaking = ValueNotifier<String?>(null);
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;

    await _tts.awaitSpeakCompletion(true);
    await _tts.setLanguage("ar-SA");
    final langResult = await _tts.setLanguage("ar-SA");
    debugPrint("setLanguage result: $langResult");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.45);

    _tts.setCompletionHandler(() {
      debugPrint("TTS: completed");
      currentlySpeaking.value = null;
    });

    _tts.setCancelHandler(() {
      debugPrint("TTS: cancelled");
      currentlySpeaking.value = null;
    });

    _tts.setErrorHandler((msg) {
      debugPrint("TTS ERROR: $msg");
      currentlySpeaking.value = null;
    });

    _initialized = true;
  }

  Future<void> speakOrToggle(String id, String text) async {
    await _init(); // ensure ready before speaking

    if (currentlySpeaking.value == id) {
      await stop();
      return;
    }

    await _tts.stop();
    currentlySpeaking.value = id;

    debugPrint("TTS: speaking -> $text");
    final result = await _tts.speak(text);
    debugPrint("TTS: speak() returned -> $result"); // 1 = success, 0/negative = failed
  }

  Future<void> stop() async {
    await _tts.stop();
    currentlySpeaking.value = null;
  }

  bool isSpeaking(String id) => currentlySpeaking.value == id;

  void dispose() {
    _tts.stop();
    currentlySpeaking.dispose();
  }
}