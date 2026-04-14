import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/result_model.dart';

// Service TFLite for LSTM inference
class TFLiteService {
  static const String defaultMetadataAssetPath =
      'assets/data/lstm_dataset_meta.json';

  bool _isInitialized = false;
  LstmDatasetMetadata? _metadata;

  TFLiteService();

  // Load metadata and prepare the service with validation
  Future<void> initialize(
    String modelPath, {
    String metadataAssetPath = defaultMetadataAssetPath,
  }) async {
    try {
      // Validate model file exists (if path is a file)
      if (!modelPath.startsWith('assets/')) {
        final modelFile = File(modelPath);
        if (!modelFile.existsSync()) {
          throw FileSystemException('Model file not found at: $modelPath');
        }
      }

      // Load and validate metadata
      _metadata = await _loadMetadata(metadataAssetPath);
      if (_metadata == null || _metadata!.classNames.isEmpty) {
        throw Exception('Invalid metadata: missing class names');
      }

      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      throw Exception('Failed to initialize TFLite service: $e');
    }
  }

  // Load and parse metadata JSON
  Future<LstmDatasetMetadata> _loadMetadata(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      if (jsonString.isEmpty) {
        throw Exception('Metadata file is empty: $assetPath');
      }

      final Map<String, dynamic> json = jsonDecode(jsonString);

      final seqLen = json['seq_len'] as int? ?? 10;
      final numFeatures = json['num_features'] as int? ?? 126;

      final classNames = List<String>.from(
        (json['class_names'] as List<dynamic>?)?.cast<String>() ?? [],
      );

      final landmarkCols = List<String>.from(
        (json['landmark_cols'] as List<dynamic>?)?.cast<String>() ?? [],
      );

      // Scaler values are optional; use defaults if not present
      final scalerMeanRaw = json['scaler_mean'] as List<dynamic>? ?? [];
      final scalerScaleRaw = json['scaler_scale'] as List<dynamic>? ?? [];

      final scalerMean = scalerMeanRaw.isEmpty
          ? List<double>.filled(numFeatures, 0.0, growable: false)
          : scalerMeanRaw
                .map((v) => (v as num?)?.toDouble() ?? 0.0)
                .toList(growable: false);

      final scalerScale = scalerScaleRaw.isEmpty
          ? List<double>.filled(numFeatures, 1.0, growable: false)
          : scalerScaleRaw
                .map((v) => (v as num?)?.toDouble() ?? 1.0)
                .toList(growable: false);

      return LstmDatasetMetadata(
        seqLen: seqLen,
        numFeatures: numFeatures,
        classNames: classNames,
        landmarkCols: landmarkCols,
        scalerMean: scalerMean,
        scalerScale: scalerScale,
        sourcePath: assetPath,
      );
    } catch (e) {
      throw Exception('Failed to load metadata from $assetPath: $e');
    }
  }

  /// Execute inference on normalized sequence with timeout protection
  /// Returns RecognitionResultData with confidence clamped to [0.0, 1.0]
  Future<RecognitionResultData> runInference(
    List<List<double>> sequence, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    // Validate input FIRST (independent of initialization state)
    if (sequence.isEmpty) {
      return _buildResultData(
        gesture: 'NoData',
        confidence: 0.0,
        sequenceLength: 0,
        debug: 'Input sequence is empty.',
      );
    }

    // Check initialization state
    if (!_isInitialized || _metadata == null) {
      return _buildResultData(
        gesture: 'NotInitialized',
        confidence: 0.0,
        sequenceLength: sequence.length,
        debug: 'Service not initialized. Call initialize() first.',
      );
    }

    // Validate sequence length against loaded metadata
    if (sequence.length != _metadata!.seqLen) {
      return _buildResultData(
        gesture: 'InvalidInput',
        confidence: 0.0,
        sequenceLength: sequence.length,
        debug:
            'Sequence length mismatch. Expected ${_metadata!.seqLen}, got ${sequence.length}',
      );
    }

    try {
      final startTime = DateTime.now();

      // TODO: Implement actual TFLite model inference
      // PLACEHOLDER: Replace with actual TFLite API calls
      // 1. Load the model from _modelPath using tflite_flutter
      // 2. Format sequence as input tensor
      // 3. Run inference and get output logits
      // 4. Apply softmax to get probabilities
      // 5. Sort by confidence to get top predictions

      await _performInferenceWithTimeout(timeout);

      final processingTimeMs = DateTime.now()
          .difference(startTime)
          .inMilliseconds;

      // Placeholder prediction
      final primaryIdx = 0;
      final classNames = _metadata!.classNames;
      final gesture = classNames.isNotEmpty && primaryIdx < classNames.length
          ? classNames[primaryIdx]
          : 'Unknown';

      return _buildResultData(
        gesture: gesture,
        confidence: 0.0,
        sequenceLength: sequence.length,
        debug:
            'TFLite inference placeholder. Will implement with actual model.',
        processingTime: processingTimeMs,
      );
    } on TimeoutException {
      return _buildResultData(
        gesture: 'Timeout',
        confidence: 0.0,
        sequenceLength: sequence.length,
        debug: 'Inference exceeded ${timeout.inSeconds}s timeout.',
      );
    } catch (e) {
      return _buildResultData(
        gesture: 'Error',
        confidence: 0.0,
        sequenceLength: sequence.length,
        debug: 'Inference error: $e',
      );
    }
  }

  /// Simulated inference with timeout protection
  /// Will be replaced with actual TFLite model execution
  Future<void> _performInferenceWithTimeout(Duration timeout) async {
    final completer = Completer<void>();
    Future.delayed(Duration.zero).then((_) => completer.complete());
    return completer.future.timeout(timeout);
  }

  /// Helper to build result data consistently with validation
  RecognitionResultData _buildResultData({
    required String gesture,
    required double confidence,
    required int sequenceLength,
    required String debug,
    int processingTime = 0,
  }) {
    return RecognitionResultData(
      primaryGesture: gesture,
      primaryGestureAr: gesture,
      primaryConfidence: confidence.clamp(0.0, 1.0),
      processingTime: processingTime,
      sequenceLength: sequenceLength,
      debug: debug,
    );
  }

  // Release resources
  void dispose() {
    _isInitialized = false;
    _metadata = null;
  }

  bool get isInitialized => _isInitialized;
  LstmDatasetMetadata? get metadata => _metadata;
}

// LSTM Dataset Metadata - loads from JSON configuration
class LstmDatasetMetadata {
  final int seqLen;
  final int numFeatures;
  final List<String> classNames;
  final List<String> landmarkCols;
  final List<double> scalerMean;
  final List<double> scalerScale;
  final String sourcePath;

  const LstmDatasetMetadata({
    required this.seqLen,
    required this.numFeatures,
    required this.classNames,
    required this.landmarkCols,
    required this.scalerMean,
    required this.scalerScale,
    required this.sourcePath,
  });

  // Get Arabic name for gesture (TODO: Add mapping)
  String getGestureNameAr(String gestureName) {
    // TODO: Implement gesture name translation mapping
    return gestureName;
  }

  int get numClasses => classNames.length;
}
