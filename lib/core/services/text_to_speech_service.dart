// Text to Speech Service - Mobile only
// Disabled for web testing - Noop implementation

class TextToSpeechService {
  bool _isInitialized = false;
  bool _isSpeaking = false;

  TextToSpeechService();

  /// Initialize TTS
  Future<void> initialize() async {
    _isInitialized = true;
  }

  /// Speak text
  Future<void> speak(String text) async {
    try {
      if (!_isInitialized) await initialize();
      if (text.isEmpty) return;
      _isSpeaking = true;
      await Future.delayed(const Duration(milliseconds: 100));
      _isSpeaking = false;
    } catch (e) {
      print('Error speaking text: $e');
      _isSpeaking = false;
    }
  }

  /// Stop speech
  Future<void> stop() async {
    _isSpeaking = false;
  }

  /// Pause speech
  Future<void> pause() async {
    _isSpeaking = false;
  }

  /// Set speech rate (0.0 - 2.0, default 1.0)
  Future<void> setSpeechRate(double rate) async {
    // No-op for web
  }

  /// Set pitch (0.5 - 2.0, default 1.0)
  Future<void> setPitch(double pitch) async {
    // No-op for web
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    // No-op for web
  }

  /// Get available languages
  Future<List<String>> getAvailableLanguages() async {
    return ['ar-SA', 'en-US', 'fr-FR'];
  }

  /// Check if speech is currently playing
  bool get isSpeaking => _isSpeaking;

  /// Dispose resources
  Future<void> dispose() async {
    _isSpeaking = false;
  }
}
