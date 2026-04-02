import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(false) bool enableTTS,
    @Default(1.0) double speechRate,
    @Default(1.0) double voicePitch,
    @Default(true) bool enableVibration,
    @Default(true) bool enableSound,
    @Default('ar') String language, // 'ar' for Arabic, 'en' for English, 'fr' for French
    @Default('high') String cameraResolution, // 'low', 'medium', 'high'
    @Default(30) int sequenceLength, // frames to collect before inference
    @Default(0.7) double confidenceThreshold,
    @Default(false) bool isDarkMode,
    @Default(true) bool showDebugInfo,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
