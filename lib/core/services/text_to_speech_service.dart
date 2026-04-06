import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  TextToSpeechService._();

  static final TextToSpeechService instance = TextToSpeechService._();

  FlutterTts? _tts;
  bool _isInitialized = false;
  bool _isSpeaking = false;
  String _language = 'ar-SA';
  double _speechRate = 1.0;
  double _pitch = 1.0;

  // Initialize TTS
  Future<void> initialize() async {
    if (_isInitialized) return;

    if (kIsWeb) {
      _isInitialized = true;
      return;
    }

    _tts = FlutterTts();
    await _tts!.setLanguage(_language);
    await _tts!.setSpeechRate(_speechRate);
    await _tts!.setPitch(_pitch);
    await _tts!.setVolume(1.0);
    await _tts!.awaitSpeakCompletion(true);

    _tts!.setStartHandler(() {
      _isSpeaking = true;
    });
    _tts!.setCompletionHandler(() {
      _isSpeaking = false;
    });
    _tts!.setCancelHandler(() {
      _isSpeaking = false;
    });
    _tts!.setErrorHandler((_) {
      _isSpeaking = false;
    });

    _isInitialized = true;
  }

  // Speak text
  Future<void> speak(String text) async {
    try {
      if (!_isInitialized) await initialize();
      if (text.trim().isEmpty) return;

      if (_tts == null) {
        return;
      }

      await _tts!.stop();
      _isSpeaking = true;
      await _tts!.speak(text);
      _isSpeaking = false;
    } catch (e) {
      debugPrint('Error speaking text: $e');
      _isSpeaking = false;
    }
  }

  // Stop speech
  Future<void> stop() async {
    if (!_isInitialized) return;
    await _tts?.stop();
    _isSpeaking = false;
  }

  // Pause speech
  Future<void> pause() async {
    if (!_isInitialized) return;
    await _tts?.pause();
    _isSpeaking = false;
  }

  // Set speech rate (0.0 - 2.0, default 1.0)
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.5, 2.0);
    if (!_isInitialized) return;
    await _tts?.setSpeechRate(_speechRate);
  }

  // Set pitch (0.5 - 2.0, default 1.0)
  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    if (!_isInitialized) return;
    await _tts?.setPitch(_pitch);
  }

  // Set language
  Future<void> setLanguage(String language) async {
    _language = _normalizeLanguage(language);
    if (!_isInitialized) return;
    await _tts?.setLanguage(_language);
  }

  // Applies the three main runtime speech parameters
  Future<void> configure({
    required String language,
    required double speechRate,
    required double pitch,
  }) async {
    if (!_isInitialized) await initialize();
    await setLanguage(language);
    await setSpeechRate(speechRate);
    await setPitch(pitch);
  }

  // Get available languages
  Future<List<String>> getAvailableLanguages() async {
    if (!_isInitialized) await initialize();
    return (await _tts?.getLanguages)
            ?.map((language) => language.toString())
            .toList() ??
        ['ar-SA', 'en-US', 'fr-FR'];
  }

  // Check if speech is currently playing
  bool get isSpeaking => _isSpeaking;

  // Dispose resources
  Future<void> dispose() async {
    await _tts?.stop();
    _tts = null;
    _isSpeaking = false;
    _isInitialized = false;
  }

  String _normalizeLanguage(String language) {
    switch (language) {
      case 'ar':
        return 'ar-SA';
      case 'en':
        return 'en-US';
      case 'fr':
        return 'fr-FR';
      default:
        return language;
    }
  }
}
