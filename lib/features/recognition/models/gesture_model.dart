import 'package:freezed_annotation/freezed_annotation.dart';

part 'gesture_model.freezed.dart';
part 'gesture_model.g.dart';

@freezed
class GestureModel with _$GestureModel {
  const factory GestureModel({
    required String id,
    required String name,
    required String nameAr,
    required String description,
    @Default([]) List<List<double>> landmarks, // Sequence of hand landmarks (21 points per frame)
    @Default(0) int frameCount,
  }) = _GestureModel;

  factory GestureModel.fromJson(Map<String, dynamic> json) =>
      _$GestureModelFromJson(json);
}

@freezed
class RecognitionResult with _$RecognitionResult {
  const factory RecognitionResult({
    required String gesture,
    required double confidence,
    @Default([]) List<RecognitionMatch> alternatives,
    @Default(0) int processingTimeMs,
  }) = _RecognitionResult;

  factory RecognitionResult.fromJson(Map<String, dynamic> json) =>
      _$RecognitionResultFromJson(json);
}

@freezed
class RecognitionMatch with _$RecognitionMatch {
  const factory RecognitionMatch({
    required String gesture,
    required double confidence,
  }) = _RecognitionMatch;

  factory RecognitionMatch.fromJson(Map<String, dynamic> json) =>
      _$RecognitionMatchFromJson(json);
}

// Hand landmark data structure (21 landmarks per hand)
@freezed
class HandLandmark with _$HandLandmark {
  const factory HandLandmark({
    required double x,
    required double y,
    required double z,
    required double visibility,
  }) = _HandLandmark;

  factory HandLandmark.fromJson(Map<String, dynamic> json) =>
      _$HandLandmarkFromJson(json);
}
