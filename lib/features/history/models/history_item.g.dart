// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryItemImpl _$$HistoryItemImplFromJson(Map<String, dynamic> json) =>
    _$HistoryItemImpl(
      id: json['id'] as String,
      recognizedText: json['recognizedText'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      confidence: (json['confidence'] as num).toDouble(),
      alternatives:
          (json['alternatives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      imageUrl: json['imageUrl'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HistoryItemImplToJson(_$HistoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recognizedText': instance.recognizedText,
      'timestamp': instance.timestamp.toIso8601String(),
      'confidence': instance.confidence,
      'alternatives': instance.alternatives,
      'imageUrl': instance.imageUrl,
      'duration': instance.duration,
    };
