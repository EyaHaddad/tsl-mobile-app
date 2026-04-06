import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

// Manages the 10-frame sliding window sent to the LSTM
// 
// Simple goal:
// - keep exactly 10 frames
// - return data in shape (1, 10, 126)
// - apply the same scaler used during training
class SequenceManager {
  // Real Flutter asset path where metadata is stored
  static const String defaultMetaAssetPath =
      'assets/data/lstm_dataset_meta.json';

  static const int seqLen = 10;
  static const int defaultTrainingStride = 2;
  static const int featureCount = 126;

  final int realtimeStride;
  final List<double> _scalerMean;
  final List<double> _scalerScale;
  final List<List<double>> _window = <List<double>>[];

  int _framesSinceLastEmit = 0;

  SequenceManager({
    required List<double> scalerMean,
    required List<double> scalerScale,
    this.realtimeStride = 1,
  }) : _scalerMean = List<double>.from(scalerMean, growable: false),
       _scalerScale = List<double>.from(scalerScale, growable: false) {
    if (_scalerMean.length != featureCount ||
        _scalerScale.length != featureCount) {
      throw ArgumentError(
        'Scaler vectors must have length $featureCount for 2x21x3 features.',
      );
    }
    if (realtimeStride < 1) {
      throw ArgumentError('realtimeStride must be >= 1');
    }
  }

  // Loads scaler values and dataset settings from metadata JSON
  static Future<SequenceManager> fromMetaAsset(
    String assetPath, {
    int realtimeStride = 1,
  }) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid lstm metadata JSON format.');
    }

    final dynamic meanRaw = decoded['scaler_mean'];
    final dynamic scaleRaw = decoded['scaler_scale'];
    final dynamic seqLenRaw = decoded['seq_len'];

    if (seqLenRaw is num && seqLenRaw.toInt() != seqLen) {
      throw FormatException(
        'seq_len mismatch. Expected $seqLen, got $seqLenRaw',
      );
    }

    if (meanRaw is! List || scaleRaw is! List) {
      throw const FormatException(
        'Missing scaler_mean or scaler_scale in lstm_dataset_meta.json',
      );
    }

    final scalerMean = meanRaw
        .map((value) => (value as num?)?.toDouble() ?? 0.0)
        .toList(growable: false);
    final scalerScale = scaleRaw
        .map((value) => (value as num?)?.toDouble() ?? 1.0)
        .toList(growable: false);

    return SequenceManager(
      scalerMean: scalerMean,
      scalerScale: scalerScale,
      realtimeStride: realtimeStride,
    );
  }

  // Shortcut to use the default metadata asset path
  static Future<SequenceManager> fromDefaultMetaAsset({
    int realtimeStride = 1,
  }) {
    return fromMetaAsset(defaultMetaAssetPath, realtimeStride: realtimeStride);
  }

  void reset() {
    _window.clear();
    _framesSinceLastEmit = 0;
  }

  // Adds one frame of features
  // Returns true when the window is ready and stride condition is met
  bool addFrameFeatures(List<double> frameFeatures) {
    final sanitized = _sanitizeFrame(frameFeatures);
    _window.add(sanitized);
    if (_window.length > seqLen) {
      _window.removeAt(0);
    }

    _framesSinceLastEmit++;
    return isReady && _framesSinceLastEmit >= realtimeStride;
  }

  bool get isReady => _window.length == seqLen;

  // Returns shape (1, 10, 126) flattened in row-major order as float32
  Float32List? buildModelInputFloat32() {
    if (!isReady) {
      return null;
    }

    _framesSinceLastEmit = 0;
    final output = Float32List(seqLen * featureCount);
    int offset = 0;

    for (final frame in _window) {
      for (int i = 0; i < featureCount; i++) {
        final cleaned = frame[i].isNaN ? 0.0 : frame[i];
        final scale = _scalerScale[i] == 0.0 ? 1.0 : _scalerScale[i];
        final standardized = (cleaned - _scalerMean[i]) / scale;
        output[offset++] = standardized.toDouble();
      }
    }

    return output;
  }

  // Returns the normalized 2D window (10 x 126)
  // Useful for debug before sending to TFLite
  List<List<double>>? buildModelInput2D() {
    if (!isReady) {
      return null;
    }

    _framesSinceLastEmit = 0;
    return _window
        .map((frame) {
          final normalized = List<double>.filled(featureCount, 0.0);
          for (int i = 0; i < featureCount; i++) {
            final cleaned = frame[i].isNaN ? 0.0 : frame[i];
            final scale = _scalerScale[i] == 0.0 ? 1.0 : _scalerScale[i];
            normalized[i] = (cleaned - _scalerMean[i]) / scale;
          }
          return normalized;
        })
        .toList(growable: false);
  }

  List<int> get modelInputShape => const <int>[1, seqLen, featureCount];

  // Cleans one frame:
  // - fills missing values with 0
  // - trims extra values
  // - replaces NaN by 0
  List<double> _sanitizeFrame(List<double> features) {
    final sanitized = List<double>.filled(featureCount, 0.0);
    final count = features.length < featureCount
        ? features.length
        : featureCount;

    for (int i = 0; i < count; i++) {
      final value = features[i];
      sanitized[i] = value.isNaN ? 0.0 : value;
    }

    return sanitized;
  }
}
