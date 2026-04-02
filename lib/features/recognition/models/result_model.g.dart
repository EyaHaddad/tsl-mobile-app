// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecognitionResultDataImpl _$$RecognitionResultDataImplFromJson(
  Map<String, dynamic> json,
) => _$RecognitionResultDataImpl(
  primaryGesture: json['primaryGesture'] as String,
  primaryGestureAr: json['primaryGestureAr'] as String,
  primaryConfidence: (json['primaryConfidence'] as num).toDouble(),
  alternatives:
      (json['alternatives'] as List<dynamic>?)
          ?.map((e) => AlternativeMatch.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  processingTime: (json['processingTime'] as num?)?.toInt() ?? 0,
  sequenceLength: (json['sequenceLength'] as num?)?.toInt() ?? 0,
  debug: json['debug'] as String? ?? '',
);

Map<String, dynamic> _$$RecognitionResultDataImplToJson(
  _$RecognitionResultDataImpl instance,
) => <String, dynamic>{
  'primaryGesture': instance.primaryGesture,
  'primaryGestureAr': instance.primaryGestureAr,
  'primaryConfidence': instance.primaryConfidence,
  'alternatives': instance.alternatives,
  'processingTime': instance.processingTime,
  'sequenceLength': instance.sequenceLength,
  'debug': instance.debug,
};

_$AlternativeMatchImpl _$$AlternativeMatchImplFromJson(
  Map<String, dynamic> json,
) => _$AlternativeMatchImpl(
  gesture: json['gesture'] as String,
  gestureAr: json['gestureAr'] as String,
  confidence: (json['confidence'] as num).toDouble(),
);

Map<String, dynamic> _$$AlternativeMatchImplToJson(
  _$AlternativeMatchImpl instance,
) => <String, dynamic>{
  'gesture': instance.gesture,
  'gestureAr': instance.gestureAr,
  'confidence': instance.confidence,
};
