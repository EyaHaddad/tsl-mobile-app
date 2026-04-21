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

    print('⚙️ [MEDIAPIPE] Initialisation en cours...');
    final initialized = await _channel.invokeMethod<bool>(
      'initializeHandLandmarker',
      <String, dynamic>{
        'minHandDetectionConfidence': 0.2, // PANIC MODE: très bas pour forcer détection
        'minHandPresenceConfidence': 0.2,
      },
    );
    if (initialized != true) {
      print('❌ [MEDIAPIPE] Initialisation ÉCHOUÉE!');
      throw PlatformException(
        code: 'mediapipe_init_failed',
        message: 'Failed to initialize native MediaPipe hand landmarker.',
      );
    }

    print('✅ [MEDIAPIPE] Initialisée avec succès');
    _isInitialized = true;
  }

  // Reserved for future camera-native integration
  dynamic get cameraController => null;

  // Detect hands and return standardized landmarks ordered left hand then right hand
  // The output contains 42 landmarks (2 x 21). Missing hands are zero-filled
  // Supported input: Uint8List (encoded image bytes) or String file path
  Future<List<HandLandmark>?> detectHands(
    dynamic image, {
    int width = 320,
    int height = 240,
    int rotation = 0,
  }) async {
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
      <String, dynamic>{
        'bytes': bytes,
        'width': width,
        'height': height,
        'rotation': rotation,    // ← AJOUTER rotation
        'isRaw': true, // Indique que c'est du Plan Y direct, pas une image compressée
        'format': 'grayscale', // Format en niveaux de gris
      },
    );

    return _parseOrderedHands(raw);
  }

  // Detect hands and return one frame vector with strict shape 126:
  // left hand lm0..20 (x,y,z), then right hand lm0..20 (x,y,z)
  Future<List<double>> detectFrameFeatures(
    dynamic image, {
    int width = 320,
    int height = 240,
    int rotation = 0,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (kIsWeb) {
      return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
    }

    final bytes = await _resolveImageBytes(image);
    
    // DIAGNOSTIC: Vérifier si la caméra envoie vraiment des données
    if (bytes == null || bytes.isEmpty) {
      print('📸 [ERREUR] MediaPipe: Aucun octet reçu de la caméra!');
      return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
    }

    try {
      // Appel natif avec mesure du temps
      print('📱 [MEDIAPIPE_NATIVE_CALL] Envoi ${bytes.length} bytes (${width}x${height}, rotation: ${rotation}°) au code natif...');
      final stopwatch = Stopwatch()..start();
      final raw = await _channel.invokeMethod<dynamic>(
        'detectHands',
        <String, dynamic>{
          'bytes': bytes,
          'width': width,
          'height': height,
          'rotation': rotation,    // ← AJOUTER rotation
          'isRaw': true, // Indique que c'est du Plan Y direct, pas une image compressée
          'format': 'grayscale', // Format en niveaux de gris
        },
      );
      stopwatch.stop();
      
      // Analyse de la réponse
      if (raw == null) {
        print('⚠️ [MEDIAPIPE_RESPONSE] Code natif retourné NULL après ${stopwatch.elapsedMilliseconds}ms');
        return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
      }
      
      if (raw is! Map) {
        print('❌ [MEDIAPIPE_ERROR] Réponse invalide: not a Map, got ${raw.runtimeType}');
        return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
      }

      final dynamic rawFeatures = raw['frameFeatures'];
      if (rawFeatures is! List) {
        print('❌ [MEDIAPIPE_ERROR] frameFeatures invalide: got ${rawFeatures.runtimeType}');
        return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
      }

      // Compter les landmarks non-zéro
      final nonZero = rawFeatures.where((f) => (f as num?) != 0).length;
      if (nonZero == 0) {
        print('⚠️ [MEDIAPIPE_DETECTION] Aucun landmark après ${stopwatch.elapsedMilliseconds}ms (128 zéros)');
      } else {
        print('✓ [MEDIAPIPE_DETECTION] ${stopwatch.elapsedMilliseconds}ms → $nonZero landmarks détectés / 126 total');
      }

      final features = rawFeatures
          .map((value) => (value as num?)?.toDouble() ?? 0.0)
          .take(_featureCountPerFrame)
          .toList(growable: false);

      // ✅ POINT C: Validate structure after cast removal
      if (features.length != _featureCountPerFrame) {
        print('❌ [LANDMARK_VALIDATION] Wrong size: ${features.length} != $_featureCountPerFrame');
        print('[LANDMARK_DEBUG] First 10 values: ${features.take(10).toList()}');
        return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
      }

      return features;

    } catch (e) {
      print('❌ [MEDIAPIPE_EXCEPTION] ${e.runtimeType}: $e');
      print('📍 Cause: C''est peut-être que le code natif n''est pas correctement chargé');
      return List<double>.filled(_featureCountPerFrame, 0.0, growable: false);
    }
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
      // Unsupported image payload type - continue to check for CameraImage
    }

    // FALLBACK: Si on reçoit un CameraImage par erreur, extraire le plan Y
    // (Cela ne devrait pas arriver car recognition_controller fait déjà la conversion)
    try {
      final planesField = image.planes;
      if (planesField != null && planesField.isNotEmpty) {
        final bytes = planesField.first.bytes;
        if (bytes != null && bytes.isNotEmpty) {
          print('⚠️ [MEDIAPIPE] CameraImage reçu directement - extraction plan Y...');
          return bytes;
        }
      }
    } catch (_) {
      // Pas un CameraImage, ou pas d'accès aux plans
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
