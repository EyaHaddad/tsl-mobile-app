import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/settings_model.dart';

class SettingsService {
  static const String _settingsKey = 'tslr_settings';
  final SharedPreferences _prefs;

  late AppSettings _currentSettings;

  SettingsService(this._prefs) {
    _initializeSettings();
  }

  void _initializeSettings() {
    final jsonString = _prefs.getString(_settingsKey);
    if (jsonString != null) {
      try {
        _currentSettings = AppSettings.fromJson(jsonDecode(jsonString));
      } catch (e) {
        _currentSettings = const AppSettings();
      }
    } else {
      _currentSettings = const AppSettings();
    }
  }

  /// Get current settings
  AppSettings getSettings() => _currentSettings;

  /// Save settings
  Future<void> saveSettings(AppSettings settings) async {
    try {
      _currentSettings = settings;
      await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  /// Update a single setting
  Future<void> updateSetting(
      Future<AppSettings> Function(AppSettings) updater) async {
    try {
      final updated = await updater(_currentSettings);
      await saveSettings(updated);
    } catch (e) {
      print('Error updating setting: $e');
    }
  }

  /// Toggle TTS
  Future<void> toggleTTS() async {
    await updateSetting((current) async =>
        current.copyWith(enableTTS: !current.enableTTS));
  }

  /// Update speech rate
  Future<void> setSpeechRate(double rate) async {
    await updateSetting(
        (current) async => current.copyWith(speechRate: rate.clamp(0.5, 2.0)));
  }

  /// Update voice pitch
  Future<void> setVoicePitch(double pitch) async {
    await updateSetting(
        (current) async => current.copyWith(voicePitch: pitch.clamp(0.5, 2.0)));
  }

  /// Update language
  Future<void> setLanguage(String language) async {
    await updateSetting((current) async => current.copyWith(language: language));
  }

  /// Update camera resolution
  Future<void> setCameraResolution(String resolution) async {
    await updateSetting(
        (current) async => current.copyWith(cameraResolution: resolution));
  }

  /// Update sequence length
  Future<void> setSequenceLength(int length) async {
    await updateSetting((current) async => current.copyWith(
          sequenceLength: length.clamp(10, 60),
        ));
  }

  /// Update confidence threshold
  Future<void> setConfidenceThreshold(double threshold) async {
    await updateSetting((current) async => current.copyWith(
          confidenceThreshold: threshold.clamp(0.0, 1.0),
        ));
  }

  /// Toggle vibration
  Future<void> toggleVibration() async {
    await updateSetting((current) async =>
        current.copyWith(enableVibration: !current.enableVibration));
  }

  /// Toggle sound
  Future<void> toggleSound() async {
    await updateSetting(
        (current) async => current.copyWith(enableSound: !current.enableSound));
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    await updateSetting(
        (current) async => current.copyWith(isDarkMode: !current.isDarkMode));
  }

  /// Toggle debug info
  Future<void> toggleDebugInfo() async {
    await updateSetting((current) async =>
        current.copyWith(showDebugInfo: !current.showDebugInfo));
  }

  /// Reset to defaults
  Future<void> resetToDefaults() async {
    await saveSettings(const AppSettings());
  }
}
