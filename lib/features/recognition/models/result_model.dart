import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_model.freezed.dart';
part 'result_model.g.dart';

@freezed
class RecognitionResultData with _$RecognitionResultData {
  const factory RecognitionResultData({
    required String primaryGesture,
    required String primaryGestureAr,
    required double primaryConfidence,
    @Default([]) List<AlternativeMatch> alternatives,
    @Default(0) int processingTime, // ms
    @Default(0) int sequenceLength, // number of frames
    @Default('') String debug, // for debugging
  }) = _RecognitionResultData;

  factory RecognitionResultData.fromJson(Map<String, dynamic> json) =>
      _$RecognitionResultDataFromJson(json);
}

@freezed
class AlternativeMatch with _$AlternativeMatch {
  const factory AlternativeMatch({
    required String gesture,
    required String gestureAr,
    required double confidence,
  }) = _AlternativeMatch;

  factory AlternativeMatch.fromJson(Map<String, dynamic> json) =>
      _$AlternativeMatchFromJson(json);
}
