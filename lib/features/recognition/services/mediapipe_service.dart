import '../models/gesture_model.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// MediaPipe service for hand detection and landmark extraction
class MediaPipeService {
  // Android bridge used to call native MediaPipe code
  static const MethodChannel _channel = MethodChannel(
    'tsl_mobile_app/mediapipe',
  );
  static const int _landmarksPerHand = 21;
  static const int _handsPerFrame = 2;
  static const int _coordsPerLandmark = 3;
  static const int _featureCountPerFrame =
      _handsPerFrame * _landmarksPerHand * _coordsPerLandmark;

  bool _isInitialized = false;

  MediaPipeService();

  // Initialize native hand landmarker
  Future<void> initialize() async {
    if (kIsWeb) {
      _isInitialized = true;
      return;
    }

    final initialized = await _channel.invokeMethod<bool>(
      'initializeHandLandmarker',
    );
    if (initialized != true) {
      throw PlatformException(
        code: 'mediapipe_init_failed',
        message: 'Failed to initialize native MediaPipe hand landmarker.',
      );
    }

    _isInitialized = true;
  }

  // Reserved for future camera-native integration
  dynamic get cameraController => null;

  // Detect hands and return standardized landmarks ordered left hand then right hand
  // The output contains 42 landmarks (2 x 21). Missing hands are zero-filled
  // Supported input: Uint8List (encoded image bytes) or String file path
  Future<List<HandLandmark>?> detectHands(dynamic image) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (kIsWeb) {
      return null;
    }

    final bytes = await _resolveImageBytes(image);
    if (bytes == null || bytes.isEmpty) {
      return [];
    }

    // Native side returns one payload with leftLandmarks/rightLandmarks/frameFeatures
    final raw = await _channel.invokeMethod<dynamic>(
      'detectHands',
      <String, dynamic>{'bytes': bytes},
    );

    return _parseOrderedHands(raw);
  }

  // Detect hands and return one frame vector with strict shape 126:
  // left hand lm0..20 (x,y,z), then right hand lm0..20 (x,y,z)
  Future<List<double>> detectFrameFeatures(dynamic image) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (kIsWeb) {
      return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
    }

    final bytes = await _resolveImageBytes(image);
    if (bytes == null || bytes.isEmpty) {
      return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
    }

    // We reuse the same native method and extract the flattened features
    final raw = await _channel.invokeMethod<dynamic>(
      'detectHands',
      <String, dynamic>{'bytes': bytes},
    );

    if (raw is! Map) {
      return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
    }

    final dynamic rawFeatures = raw['frameFeatures'];
    if (rawFeatures is! List) {
      return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
    }

    final features = rawFeatures
        .map((value) => (value as num?)?.toDouble() ?? 0.0)
        .take(_featureCountPerFrame)
        .toList(growable: false);

    if (features.length != _featureCountPerFrame) {
      return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
    }

    return features;
  }

  // Convert raw detection payload to standardized HandLandmark list
  List<HandLandmark> processLandmarks(Map<String, dynamic> detectionData) {
    return _parseOrderedHands(detectionData);
  }

  // Check if hands are detected
  Future<bool> areHandsDetected(dynamic image) async {
    final landmarks = await detectHands(image);
    return getHandCount(landmarks ?? const []) > 0;
  }

  // Get number of hands detected
  // Landmarks are ordered as: 21 left + 21 right
  int getHandCount(List<HandLandmark> landmarks) {
    if (landmarks.isEmpty) return 0;
    if (landmarks.length < _landmarksPerHand) return 0;

    int count = 0;
    final left = landmarks.take(_landmarksPerHand).toList(growable: false);
    final right = landmarks
        .skip(_landmarksPerHand)
        .take(_landmarksPerHand)
        .toList(growable: false);

    if (_isHandNonZero(left)) count++;
    if (_isHandNonZero(right)) count++;
    return count;
  }

  // Dispose native resources
  Future<void> dispose() async {
    if (!kIsWeb && _isInitialized) {
      await _channel.invokeMethod<bool>('disposeHandLandmarker');
    }
    _isInitialized = false;
  }

  bool get isInitialized => _isInitialized;

  Future<Uint8List?> _resolveImageBytes(dynamic image) async {
    if (image == null) return null;
    if (image is Uint8List) return image;

    if (image is String && image.isNotEmpty) {
      final file = File(image);
      if (!await file.exists()) return null;
      return file.readAsBytes();
    }

    try {
      // Allows passing objects like XFile that expose a "path" property
      final dynamic path = image.path;
      if (path is String && path.isNotEmpty) {
        final file = File(path);
        if (!await file.exists()) return null;
        return file.readAsBytes();
      }
    } catch (_) {
      // Unsupported image payload type
    }

    return null;
  }

  List<HandLandmark> _parseOrderedHands(dynamic raw) {
    if (raw is! Map) {
      // Always keep a stable shape for downstream LSTM logic
      return List<HandLandmark>.filled(
        _handsPerFrame * _landmarksPerHand,
        const HandLandmark(x: 0.0, y: 0.0, z: 0.0, visibility: 1.0),
        growable: false,
      );
    }

    final left = _parseSingleHand(raw['leftLandmarks']);
    final right = _parseSingleHand(raw['rightLandmarks']);
    return [...left, ...right];
  }

  List<HandLandmark> _parseSingleHand(dynamic rawHand) {
    if (rawHand is! List) {
      return List<HandLandmark>.filled(
        _landmarksPerHand,
        const HandLandmark(x: 0.0, y: 0.0, z: 0.0, visibility: 1.0),
        growable: false,
      );
    }

    final hand = rawHand
        .whereType<Map>()
        .map((item) => HandLandmark.fromJson(Map<String, dynamic>.from(item)))
        .take(_landmarksPerHand)
        .toList(growable: true);

    // Zero-padding keeps exactly 21 landmarks per hand
    while (hand.length < _landmarksPerHand) {
      hand.add(const HandLandmark(x: 0.0, y: 0.0, z: 0.0, visibility: 1.0));
    }

    return hand;
  }

  bool _isHandNonZero(List<HandLandmark> hand) {
    for (final lm in hand) {
      if (lm.x != 0.0 || lm.y != 0.0 || lm.z != 0.0) {
        return true;
      }
    }
    return false;
  }
}
