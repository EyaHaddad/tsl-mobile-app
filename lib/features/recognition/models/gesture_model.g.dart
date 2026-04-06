// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gesture_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GestureModelImpl _$$GestureModelImplFromJson(Map<String, dynamic> json) =>
    _$GestureModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      description: json['description'] as String,
      landmarks: (json['landmarks'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList())
              .toList() ??
          const [],
      frameCount: (json['frameCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$GestureModelImplToJson(_$GestureModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'description': instance.description,
      'landmarks': instance.landmarks,
      'frameCount': instance.frameCount,
    };

_$RecognitionResultImpl _$$RecognitionResultImplFromJson(
        Map<String, dynamic> json) =>
    _$RecognitionResultImpl(
      gesture: json['gesture'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      alternatives: (json['alternatives'] as List<dynamic>?)
              ?.map((e) => RecognitionMatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      processingTimeMs: (json['processingTimeMs'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RecognitionResultImplToJson(
        _$RecognitionResultImpl instance) =>
    <String, dynamic>{
      'gesture': instance.gesture,
      'confidence': instance.confidence,
      'alternatives': instance.alternatives,
      'processingTimeMs': instance.processingTimeMs,
    };

_$RecognitionMatchImpl _$$RecognitionMatchImplFromJson(
        Map<String, dynamic> json) =>
    _$RecognitionMatchImpl(
      gesture: json['gesture'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$$RecognitionMatchImplToJson(
        _$RecognitionMatchImpl instance) =>
    <String, dynamic>{
      'gesture': instance.gesture,
      'confidence': instance.confidence,
    };

_$HandLandmarkImpl _$$HandLandmarkImplFromJson(Map<String, dynamic> json) =>
    _$HandLandmarkImpl(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      visibility: (json['visibility'] as num).toDouble(),
    );

Map<String, dynamic> _$$HandLandmarkImplToJson(_$HandLandmarkImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
      'visibility': instance.visibility,
    };
