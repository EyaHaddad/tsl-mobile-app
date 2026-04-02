import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_item.freezed.dart';
part 'history_item.g.dart';

@freezed
class HistoryItem with _$HistoryItem {
  const factory HistoryItem({
    required String id,
    required String recognizedText,
    required DateTime timestamp,
    required double confidence,
    @Default([]) List<String> alternatives,
    @Default('') String imageUrl,
    @Default(0) int duration, // in milliseconds
  }) = _HistoryItem;

  factory HistoryItem.fromJson(Map<String, dynamic> json) =>
      _$HistoryItemFromJson(json);
}
