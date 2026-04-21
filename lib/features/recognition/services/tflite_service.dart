import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/result_model.dart';

// Service TFLite for LSTM inference
class TFLiteService {
  static const String defaultMetadataAssetPath =
      'assets/data/lstm_dataset_meta.json';
  static const String defaultModelPath = 'assets/models/model_float16.tflite';

  bool _isInitialized = false;
  LstmDatasetMetadata? _metadata;
  Interpreter? _interpreter;
  String? _modelPath;

  TFLiteService();

  // Load metadata and prepare the service with validation
  Future<void> initialize(
    String modelPath, {
    String metadataAssetPath = defaultMetadataAssetPath,
  }) async {
    try {
      _modelPath = modelPath;

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

      // Load TFLite model
      try {
        _interpreter = await Interpreter.fromAsset(modelPath);
      } catch (e) {
        throw Exception('Failed to load TFLite model from $modelPath: $e');
      }

      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      _interpreter = null;
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

      // Run inference with timeout protection
      final inferenceResult = await _performInferenceWithTimeout(sequence, timeout);

      final processingTimeMs = DateTime.now()
          .difference(startTime)
          .inMilliseconds;

      // Get top prediction
      final classNames = _metadata!.classNames;
      final primaryIdx = inferenceResult['primaryIdx'] as int? ?? 0;
      final confidence = inferenceResult['confidence'] as double? ?? 0.0;

      final gesture = classNames.isNotEmpty && primaryIdx < classNames.length
          ? classNames[primaryIdx]
          : 'Unknown';

      final gestureAr = _metadata!.getGestureNameAr(gesture);

      return _buildResultData(
        gesture: gesture,
        gestureAr: gestureAr,
        confidence: confidence,
        sequenceLength: sequence.length,
        debug: 'Inference completed successfully.',
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

  /// Execute TFLite model inference with timeout protection
  /// Returns map with 'primaryIdx' and 'confidence'
  Future<Map<String, dynamic>> _performInferenceWithTimeout(
    List<List<double>> sequence,
    Duration timeout,
  ) async {
    if (_interpreter == null) {
      throw Exception('Interpreter not initialized');
    }

    // Flatten and normalize sequence to 1D array: [seqLen * numFeatures]
    final flatSequence = <double>[];
    for (final frame in sequence) {
      flatSequence.addAll(frame);
    }

    // Apply normalization (z-score): (x - mean) / scale
    final normalizedSequence = _normalizeSequence(flatSequence);

    // Create input tensor as Float32List for TFLite
    final input = [Float32List.fromList(normalizedSequence)];

    // Create output tensor for logits [1, numClasses]
    final numClasses = _metadata!.numClasses;
    final outputLogits = List<List<double>>.generate(
      1,
      (_) => List<double>.filled(numClasses, 0.0),
    );

    // Run inference with timeout
    return Future.delayed(Duration.zero).then((_) {
      _interpreter!.run(input, outputLogits);

      // Get probabilities via softmax
      final logits = outputLogits[0];
      final probabilities = _applySoftmax(logits);

      // Find top prediction
      var maxIdx = 0;
      var maxProb = probabilities[0];
      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIdx = i;
        }
      }

      return {
        'primaryIdx': maxIdx,
        'confidence': maxProb.clamp(0.0, 1.0),
      };
    }).timeout(timeout);
  }

  /// Normalize sequence using scaler mean and scale from metadata
  /// Applies z-score normalization: (x - mean) / scale
  /// 
  /// IMPORTANT: The sequence is flattened (1260 elements = 10 frames * 126 features).
  /// The scaler has only 126 elements (per-feature normalization).
  /// We use modulo (%) to apply the 126-element scaler across all 1260 flattened values.
  List<double> _normalizeSequence(List<double> sequence) {
    final scalerMean = _metadata!.scalerMean;
    final scalerScale = _metadata!.scalerScale;
    final numFeatures = _metadata!.numFeatures; // Should be 126

    // Safety check: ensure scaler dimensions match the expected feature count
    if (scalerMean.length != numFeatures || scalerScale.length != numFeatures) {
      throw Exception(
          'Scaler dimension mismatch: Expected $numFeatures features, '
          'but got mean length ${scalerMean.length} and scale length ${scalerScale.length}');
    }

    // Expected sequence length after flattening: seqLen * numFeatures (10 * 126 = 1260)
    final expectedLength = _metadata!.seqLen * numFeatures;
    if (sequence.length != expectedLength) {
      throw Exception(
          'Sequence length mismatch: Expected $expectedLength (${_metadata!.seqLen} frames * $numFeatures features), '
          'but got ${sequence.length}');
    }

    return List<double>.generate(
      sequence.length, // 1260 elements
      (i) {
        // Use modulo to always point to the correct feature index (0-125)
        // regardless of which frame we're on (frame 0-9)
        final featureIdx = i % numFeatures;
        
        final normalized =
            (sequence[i] - scalerMean[featureIdx]) / scalerScale[featureIdx];
        
        // Clamp to reasonable range to prevent extreme values from outliers
        return normalized.clamp(-10.0, 10.0);
      },
    );
  }

  /// Apply softmax activation to logits
  /// Handles edge cases like empty list or extreme values
  List<double> _applySoftmax(List<double> logits) {
    if (logits.isEmpty) {
      return [];
    }

    // Find max for numerical stability
    final maxLogit = logits.reduce((a, b) => a > b ? a : b);

    // Compute stable softmax
    final expLogits =
        logits.map((x) => exp(x - maxLogit)).toList();
    final sumExp = expLogits.fold<double>(0.0, (sum, v) => sum + v);

    if (sumExp == 0.0 || sumExp.isNaN || sumExp.isInfinite) {
      // Fallback: return uniform distribution
      return List<double>.filled(logits.length, 1.0 / logits.length);
    }

    return expLogits.map((x) => x / sumExp).toList();
  }

  /// Helper to build result data consistently with validation
  RecognitionResultData _buildResultData({
    required String gesture,
    String? gestureAr,
    required double confidence,
    required int sequenceLength,
    required String debug,
    int processingTime = 0,
  }) {
    return RecognitionResultData(
      primaryGesture: gesture,
      primaryGestureAr: gestureAr ?? gesture,
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
    _interpreter?.close();
    _interpreter = null;
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

  // Get Arabic name for gesture with comprehensive mapping
  String getGestureNameAr(String gestureName) {
    const arabicNames = {
      '3aslema': 'عسلامة',
      '3ayla': 'عائلة',
      '5adamet': 'خدمة',
      '5al-3am': 'خال-عم',
      '5mis': 'خمس',
      '5ou': 'خو',
      'a7ad': 'أحد',
      'assam': 'السم',
      'baladya': 'بلاديّة',
      'banka': 'بنك',
      'barnamjk': 'برنامج',
      'bent': 'بنت',
      'bou': 'بو',
      'bousta': 'بوسطة',
      'car': 'سيارة',
      'chabeb': 'شباب',
      'cv': 'سيرة ذاتية',
      'dar': 'دار',
      'demande': 'طلب',
      'eben': 'إبن',
      'enti': 'إنتي',
      'erb3a': 'ربعة',
      'jad': 'جد',
      'jadda': 'جدة',
      'jom3a': 'جمعة',
      'karhba': 'كرهبة',
      'labes': 'لابس',
      'louage': 'لواج',
      'lyoum': 'اليوم',
      'ma7kma': 'محكمة',
      'mar2a': 'مرأة',
      'mar7ba': 'مرحبا',
      'metro': 'متروا',
      'mostawsaf': 'مستوصف',
      'n3awnek': 'نعاونك',
      'nekteblk': 'نكتبلك',
      'non': 'لا',
      'o5t': 'أخت',
      'om': 'أم',
      'oui': 'نعم',
      'radio': 'راديو',
      'sbitar': 'سبيطار',
      'se7a': 'صحة',
      'sebt': 'السبت',
      'siye7a': 'سياحة',
      't7eb': 'تحب',
      'ta3lim': 'تعليم',
      'ta3raf': 'تعرف',
      'ta9ra': 'تقرا',
      'taxi': 'تاكسي',
      'telvza': 'تلفزة',
      'tfol': 'طفل',
      'tha9afa': 'ثقافة',
      'thleth': 'ثلاثة',
      'thnin': 'إثنين',
      'train': 'قطار',
      'wzara': 'وزارة',
    };

    return arabicNames[gestureName] ?? gestureName;
  }

  int get numClasses => classNames.length;
}
