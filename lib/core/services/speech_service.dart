import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

import '../logging/safe_log.dart';

/// On-device text-to-speech (nothing is sent to a server).
abstract interface class SpeechService {
  /// Emits `true` while speaking.
  Stream<bool> get speaking;

  Future<void> speak(String text, {String locale = 'hi-IN'});

  Future<void> stop();
}

class FlutterTtsSpeech implements SpeechService {
  FlutterTtsSpeech() : _tts = FlutterTts() {
    _tts.setStartHandler(() => _state.add(true));
    _tts.setCompletionHandler(() => _state.add(false));
    _tts.setCancelHandler(() => _state.add(false));
    _tts.setErrorHandler((_) => _state.add(false));
  }

  final FlutterTts _tts;
  final _state = StreamController<bool>.broadcast();

  @override
  Stream<bool> get speaking => _state.stream;

  @override
  Future<void> speak(String text, {String locale = 'hi-IN'}) async {
    try {
      final available = await _tts.isLanguageAvailable(locale);
      await _tts.setLanguage(
        available == true
            ? locale
            : (locale.startsWith('hi') ? 'en-IN' : 'en-US'),
      );
      await _tts.setSpeechRate(
        0.42,
      ); // slower than default — clearer for older listeners
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (e) {
      SafeLog.e('tts', e);
      _state.add(false);
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
    _state.add(false);
  }
}

class SilentSpeech implements SpeechService {
  final spoken = <String>[];
  final _c = StreamController<bool>.broadcast();

  @override
  Stream<bool> get speaking => _c.stream;

  @override
  Future<void> speak(String text, {String locale = 'hi-IN'}) async =>
      spoken.add(text);

  @override
  Future<void> stop() async {}
}
