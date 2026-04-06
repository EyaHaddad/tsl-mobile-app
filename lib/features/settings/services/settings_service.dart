import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/settings_model.dart';

// Handles loading and saving app settings using SharedPreferences
class SettingsService {
  static const String _settingsKey = 'tslr_settings';
  final SharedPreferences _prefs;

  late AppSettings _currentSettings;

  SettingsService(this._prefs) {
    _initializeSettings();
  }

  // Creates a service instance with initialized shared preferences
  static Future<SettingsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsService(prefs);
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

  // Returns the in-memory settings snapshot
  AppSettings getSettings() => _currentSettings;

  // Persists settings and updates the in-memory snapshot
  Future<void> saveSettings(AppSettings settings) async {
    try {
      _currentSettings = settings;
      await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  // Applies and persists a single settings update
  Future<void> updateSetting(AppSettings Function(AppSettings) updater) async {
    try {
      final updated = updater(_currentSettings);
      await saveSettings(updated);
    } catch (e) {
      print('Error updating setting: $e');
    }
  }

  // Toggle TTS
  Future<void> toggleTTS() async {
    await updateSetting(
      (current) => current.copyWith(enableTTS: !current.enableTTS),
    );
  }

  // Update speech rate
  Future<void> setSpeechRate(double rate) async {
    await updateSetting(
      (current) => current.copyWith(speechRate: rate.clamp(0.5, 2.0)),
    );
  }

  // Update voice pitch
  Future<void> setVoicePitch(double pitch) async {
    await updateSetting(
      (current) => current.copyWith(voicePitch: pitch.clamp(0.5, 2.0)),
    );
  }

  // Update language
  Future<void> setLanguage(String language) async {
    await updateSetting((current) => current.copyWith(language: language));
  }

  // Update camera resolution
  Future<void> setCameraResolution(String resolution) async {
    await updateSetting(
      (current) => current.copyWith(cameraResolution: resolution),
    );
  }

  // Update sequence length
  Future<void> setSequenceLength(int length) async {
    await updateSetting(
      (current) => current.copyWith(sequenceLength: length.clamp(10, 60)),
    );
  }

  // Update confidence threshold
  Future<void> setConfidenceThreshold(double threshold) async {
    await updateSetting(
      (current) =>
          current.copyWith(confidenceThreshold: threshold.clamp(0.0, 1.0)),
    );
  }

  // Enable/disable automatic record deletion
  Future<void> setAutoDeleteEnabled(bool enabled) async {
    await updateSetting(
      (current) => current.copyWith(autoDeleteEnabled: enabled),
    );
  }

  // Retention duration for non-favorite records. 0 means forever
  Future<void> setRetentionDays(int days) async {
    await updateSetting((current) => current.copyWith(retentionDays: days));
  }

  // Persist generated audio files for history records
  Future<void> setPersistAudioFiles(bool persist) async {
    await updateSetting(
      (current) => current.copyWith(persistAudioFiles: persist),
    );
  }

  // Toggle vibration
  Future<void> toggleVibration() async {
    await updateSetting(
      (current) => current.copyWith(enableVibration: !current.enableVibration),
    );
  }

  // Toggle sound
  Future<void> toggleSound() async {
    await updateSetting(
      (current) => current.copyWith(enableSound: !current.enableSound),
    );
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    await updateSetting(
      (current) => current.copyWith(isDarkMode: !current.isDarkMode),
    );
  }

  // Toggle debug info
  Future<void> toggleDebugInfo() async {
    await updateSetting(
      (current) => current.copyWith(showDebugInfo: !current.showDebugInfo),
    );
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    await saveSettings(const AppSettings());
  }
}
