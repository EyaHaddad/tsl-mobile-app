// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      enableTTS: json['enableTTS'] as bool? ?? false,
      speechRate: (json['speechRate'] as num?)?.toDouble() ?? 1.0,
      voicePitch: (json['voicePitch'] as num?)?.toDouble() ?? 1.0,
      enableVibration: json['enableVibration'] as bool? ?? true,
      enableSound: json['enableSound'] as bool? ?? true,
      language: json['language'] as String? ?? 'ar',
      cameraResolution: json['cameraResolution'] as String? ?? 'high',
      sequenceLength: (json['sequenceLength'] as num?)?.toInt() ?? 30,
      confidenceThreshold:
          (json['confidenceThreshold'] as num?)?.toDouble() ?? 0.7,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      showDebugInfo: json['showDebugInfo'] as bool? ?? true,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'enableTTS': instance.enableTTS,
      'speechRate': instance.speechRate,
      'voicePitch': instance.voicePitch,
      'enableVibration': instance.enableVibration,
      'enableSound': instance.enableSound,
      'language': instance.language,
      'cameraResolution': instance.cameraResolution,
      'sequenceLength': instance.sequenceLength,
      'confidenceThreshold': instance.confidenceThreshold,
      'isDarkMode': instance.isDarkMode,
      'showDebugInfo': instance.showDebugInfo,
    };
